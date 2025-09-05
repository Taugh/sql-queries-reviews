USE max76PRD

/***************************************************************************************************
Query Name: WO_Prod_Maint_LateWorkOrders_LastMonth.sql
Location / File Path: sql/work_orders/WO_Prod_Maint_LateWorkOrders_LastMonth.sql

Purpose:
  List Production Maintenance work orders (CA/PM/RM) completed last month that finished LATE.
  "Late" = Completed > the earlier of Target Completion Date (targcompdate) and Finish No Later Than
  (fnlconstraint), ignoring NULLs. Owner teams scoped by Assigned Owner Group and/or Owner Group.

Row Grain:
  One row per Work Order.

Assumptions:
  - Completion is identified by wostatus rows with STATUS='COMP'. Some environments may also populate
    WORKORDER.actfinish; we prefer COALESCE(actfinish, completion_status.changedate) for robustness.
  - Either targcompdate or fnlconstraint may be NULL. Late baseline uses the non-NULL earliest date.

Parameters:
  @SiteID           : Target site (default 'FWN')
  @StartOfPrevMonth : First day of previous month (computed)
  @StartOfThisMonth : First day of current month (computed)
  @Groups           : Set of production maintenance teams (default: FWNLC1, FWNPS)

Filters:
  - Site, WO class/activity scope, task exclusion, worktype ∈ ('CA','PM','RM')
  - Completed LAST MONTH (latest 'COMP' status within month window)
  - Team ∈ @Groups via AssignedOwnerGroup OR OwnerGroup
  - Late vs. due baseline

Security:
  - Read-only; no sensitive columns.

Version Control:
  - Store under /sql/work_orders with paired doc under /docs/work_orders.

Change Log:
  2025-09-04  TB/M365  Refactor: early-of-two-date lateness logic, CROSS APPLY for completion,
                       SARGable dates, qualified columns, fixed ORDER BY, full header & docs.
***************************************************************************************************/

DECLARE @SiteID sysname = N'FWN';

-- Month window: [first day of previous month, first day of current month)
DECLARE @StartOfPrevMonth date = DATEADD(DAY, 1, EOMONTH(SYSDATETIME(), -2));
DECLARE @StartOfThisMonth date = DATEADD(DAY, 1, EOMONTH(SYSDATETIME(), -1));

-- Production maintenance owner groups (edit as needed)
DECLARE @Groups TABLE (GroupID sysname PRIMARY KEY);
INSERT INTO @Groups (GroupID)
VALUES (N'FWNLC1'), (N'FWNPS');

;WITH Base AS
(
    SELECT
        w.wonum,
        w.description,
        w.location,
        w.assetnum,
        w.status,
        w.worktype,
        w.assignedownergroup,
        w.owner,
        w.targcompdate,
        w.fnlconstraint,
        -- Completion date: prefer actfinish; fall back to last 'COMP' changedate in-window
        CompletedDate = COALESCE(w.actfinish, comp.changedate),
        -- Earliest due date between targcompdate and fnlconstraint (ignores NULLs)
        DueBaseline = CASE
            WHEN w.targcompdate IS NULL THEN w.fnlconstraint
            WHEN w.fnlconstraint IS NULL THEN w.targcompdate
            WHEN w.fnlconstraint <= w.targcompdate THEN w.fnlconstraint
            ELSE w.targcompdate
        END
    FROM dbo.workorder AS w
    CROSS APPLY (
        SELECT TOP (1) s.changedate
        FROM dbo.wostatus AS s
        WHERE s.wonum = w.wonum
          AND s.siteid = w.siteid
          AND s.status = 'COMP'
          AND s.changedate >= @StartOfPrevMonth
          AND s.changedate <  @StartOfThisMonth
        ORDER BY s.changedate DESC
    ) AS comp
    WHERE
        w.siteid = @SiteID
        AND w.istask = 0
        AND w.woclass IN ('WORKORDER', 'ACTIVITY')
        AND w.worktype IN ('CA','PM','RM')
        AND (
            EXISTS (SELECT 1 FROM @Groups g WHERE g.GroupID = w.assignedownergroup) OR
            EXISTS (SELECT 1 FROM @Groups g WHERE g.GroupID = w.ownergroup)
        )
)
SELECT
    wonum                     AS [Work Order],
    description              AS [Description],
    location                 AS [Location],
    assetnum                 AS [Asset],
    status                   AS [Status],
    worktype                 AS [Work Type],
    assignedownergroup       AS [Owner Group],
    owner                    AS [Assigned To],
    targcompdate             AS [Due Date],
    fnlconstraint            AS [Finish No Later Than],
    CompletedDate            AS [Completed Date]
    -- Optional transparency metrics (uncomment if useful in reporting):
    , DueBaseline          AS [Due Baseline]
    , DATEDIFF(DAY, DueBaseline, CompletedDate) AS [Days Late]
FROM Base
WHERE
    DueBaseline IS NOT NULL            -- require a due target to assess lateness
    AND CompletedDate IS NOT NULL
    AND CompletedDate > DueBaseline    -- strictly late
ORDER BY
    assignedownergroup, wonum;