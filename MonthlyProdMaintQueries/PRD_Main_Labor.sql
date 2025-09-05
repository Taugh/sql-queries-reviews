USE max76PRD

/***************************************************************************************************
Query: WO_Labor_LastMonth_TransactionGrain.sql
File Path: MonthlyProdMaintQueries/PRD_Main_Labor.sql
Repository: https://github.com/Taugh/sql-queries-reviews/blob/main/MonthlyProdMaintQueries/PRD_Main_Labor.sql

Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0

Purpose:
  Return last month's work order labor transactions for selected owner groups at a site,
  excluding WOs in WAPPR/APPR/INPRG. Row grain is one row per labtrans record.

Row Grain:
  One row per labtrans (laborcode per WO per transaction).

Key Choices:
  - INNER JOIN to labtrans: we only return WOs with labor in the window.
  - LEFT JOIN to person: preserve labor rows when display name is missing.
  - SARGable month window using precomputed boundaries (no functions on columns).
  - Safe, consistent aliases and fully qualified columns.

Parameters (edit as needed):
  @SiteID           : Site to report (default 'FWN')
  @StartOfPrevMonth : First day of previous month (computed)
  @StartOfThisMonth : First day of current month (computed)

Owner Groups:
  Use the table variable @Groups to avoid per-row function calls and keep the filter selective.
  (For reusable code, prefer a TVP parameter.)

Change Log:
  2025-09-04 TB/M365  Finalized performance-focused refactor (explicit joins, params, EOMONTH window,
                      LEFT join person, COALESCE for Name, groups table variable).
***************************************************************************************************/

DECLARE @SiteID sysname = N'FWN';

-- Compute month window: [first day prev month, first day this month)
DECLARE @StartOfPrevMonth date = DATEADD(DAY, 1, EOMONTH(SYSDATETIME(), -2));
DECLARE @StartOfThisMonth date = DATEADD(DAY, 1, EOMONTH(SYSDATETIME(), -1));

-- Owner groups filter (fast, simple, maintainable)
DECLARE @Groups TABLE (GroupID sysname PRIMARY KEY);
INSERT INTO @Groups (GroupID)
VALUES (N'FWNLC1'), (N'FWNPS'), (N'FWNLC2'), (N'FWNMOS');

SELECT
    w.wonum                               AS [Work Order],
    w.description                         AS [WO Description],
    l.laborcode                           AS [Labor],
    COALESCE(p.displayname, l.laborcode)  AS [Name],
    w.siteid                              AS [Site],
    w.assignedownergroup                  AS [Group],
    w.worktype                            AS [Work Type],
    w.status                              AS [Status],
    l.startdatetime                       AS [Start Date],
    l.finishdatetime                      AS [Complete Date],
    l.regularhrs                          AS [Time]
FROM dbo.workorder AS w
INNER JOIN dbo.labtrans AS l
    ON  l.refwo  = w.wonum
    AND l.siteid = w.siteid
LEFT JOIN dbo.person AS p
    ON  p.personid     = l.laborcode
    AND p.locationsite = l.siteid
WHERE
    w.siteid = @SiteID
    AND w.woclass IN ('WORKORDER', 'ACTIVITY')
    AND w.istask = 0
    AND w.status NOT IN ('WAPPR', 'APPR', 'INPRG')
    AND EXISTS (
        SELECT 1 FROM @Groups g WHERE g.GroupID = w.assignedownergroup
    )
    -- Within-month rule (matches your original intent):
    AND l.startdatetime  >= @StartOfPrevMonth
    AND l.finishdatetime <  @StartOfThisMonth
ORDER BY
    w.assignedownergroup, l.laborcode, w.worktype, w.wonum
OPTION (OPTIMIZE FOR (@SiteID UNKNOWN));  -- helps plan stability for ad-hoc runs