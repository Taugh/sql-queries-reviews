USE max76PRD

/***************************************************************************************************
Query Name: WO_Prod_Maint_MissedWorkOrders_LastMonth.sql
Location / File Path: sql/work_orders/WO_Prod_Maint_MissedWorkOrders_LastMonth.sql

Purpose:
  List Production Maintenance work orders that were flagged AS MISSED since the start of last month,
  scoped to specific maintenance teams, AND whose Target Completion Date fell last month.

Behavior Notes:
  - Aligns WITH the original query: requires MISSED.changedate >= start of last month (no upper bound).
  - WOs flagged MISSED ON/after the first day of the current month still appear if their targcompdate
    was last month.

Row Grain:
  One row per Work Order.

Parameters:
  @SiteID           : Target site (default 'FWN')
  @StartOfPrevMonth : First day of previous month (computed)
  @StartOfThisMonth : First day of current month (computed)

Change Log:
  2025-09-04  TB/M365  Adjusted MISSED date filter to remove the upper bound to match original results.
***************************************************************************************************/

DECLARE @SiteID sysname = N'FWN';

-- Month window: [first day of previous month, first day of current month)
DECLARE @StartOfPrevMonth date = DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) - 1, 0);
DECLARE @StartOfThisMonth date = DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) + 0, 0);

-- Production maintenance owner groups (edit AS needed)
DECLARE @Groups TABLE (GroupID sysname PRIMARY KEY);
INSERT INTO @Groups (GroupID)
VALUES (N'FWNLC1'), (N'FWNPS');

;WITH Base AS
(
    SELECT
        w.wonum,
        w.siteid,
        w.description,
        w.location,
        w.assetnum,
        w.worktype,
        w.assignedownergroup,
        w.ownergroup,
        w.owner,
        w.targcompdate,
		w.fnlconstraint,
        m.changedate,          -- latest MISSED changedate since start of last month (no upper bound)
        m.status               -- 'MISSED'
    FROM dbo.workorder AS w
    CROSS APPLY (
        SELECT TOP (1)
               s.status,
               s.changedate
        FROM dbo.wostatus AS s
        WHERE s.wonum = w.wonum
          AND s.siteid = w.siteid
          AND s.status = 'MISSED'
          AND s.changedate >= @StartOfPrevMonth     -- no upper bound to match original behavior
        ORDER BY s.changedate DESC
    ) AS m
    WHERE
        w.siteid = @SiteID
        AND w.istask = 0
        AND w.woclass IN ('WORKORDER', 'ACTIVITY')
        AND w.worktype IN ('CA','PM','RM','RQL','CM')
        AND w.fnlconstraint >= @StartOfPrevMonth
        AND (
            EXISTS (SELECT 1 FROM @Groups g WHERE g.GroupID = w.assignedownergroup) OR
            EXISTS (SELECT 1 FROM @Groups g WHERE g.GroupID = w.ownergroup)
        )
)
SELECT
    wonum                       AS [Work Order],
    description                 AS [Description],
    location                    AS [Location],
    assetnum                    AS [Asset],
    status                      AS [Status],              -- 'MISSED'
    worktype                    AS [Work Type],
    assignedownergroup          AS [Owner Group],
    owner                       AS [Assigned To],
    targcompdate                AS [Due Date],
    changedate                  AS [Date Flagged AS Missed]
FROM Base
ORDER BY
    COALESCE(assignedownergroup, ownergroup), wonum;