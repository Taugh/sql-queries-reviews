USE max76PRD

/***************************************************************************************************
Query Name: WO_Inventory_Usage_ByTeam_LastMonth.sql
Location / File Path: sql/work_orders/WO_Inventory_Usage_ByTeam_LastMonth.sql

Purpose:
  Report material requisitions (MR/MRLINE) attributed to maintenance teams (by Work Order owner
  group) for last month at a given site. Uses MR AS the source of "usage" (requested/issued
  through requisitions) AND ties lines to WOs via MRLINE.REFWO.

Row Grain:
  One row per MR line (MRLINE).

Assumptions:
  - MRLINE.REFWO links to WORKORDER.WONUM for the same SITEID.
  - MR AND MRLINE both carry SITEID AND should match to prevent cross-site joins.
  - Team ownership can be ON either WO.ASSIGNEDOWNERGROUP OR WO.OWNERGROUP.

Parameters:
  @SiteID           : Target site (default 'FWN')
  @StartOfPrevMonth : First day of previous month (computed)
  @StartOfThisMonth : First day of current month (computed)
  @Groups           : Set of owner groups to include (default: FWNLC1, FWNPS)

Filters:
  - MR at @SiteID WITH status NOT IN ('CAN','DRAFT')
  - MR.ENTERDATE within last month
  - WO team in @Groups via ASSIGNEDOWNERGROUP OR OWNERGROUP

Security:
  - Read-only; no sensitive columns.

Version Control:
  - Store under /sql/work_orders WITH a paired doc under /docs/work_orders.

Change Log:
  2025-09-04  TB/M365  Refactor for clarity & performance: site-safe joins, params, SARGable dates,
                       qualified columns, consistent casing & aliases, doc header.
***************************************************************************************************/

DECLARE @SiteID sysname = N'FWN';

-- Month window: [first day of previous month, first day of current month)
DECLARE @StartOfPrevMonth date = DATEADD(DAY, 1, EOMONTH(SYSDATETIME(), -2));
DECLARE @StartOfThisMonth date = DATEADD(DAY, 1, EOMONTH(SYSDATETIME(), -1));

-- Owner groups (edit AS needed)
DECLARE @Groups TABLE (GroupID sysname PRIMARY KEY);
INSERT INTO @Groups (GroupID)
VALUES (N'FWNLC1'), (N'FWNPS');  -- add more AS needed (e.g., FWNLC2, FWNMOS)

SELECT
    mr.mrnum					AS [Requisition],
    mr.description				AS [Requisition Description],
    mr.requestedby				AS [Requested By],
    mr.requestedfor				AS [Requested For],
    CAST(mr.enterdate AS date)  AS [Requested Date],
    mr.status					AS [Status],
    mr.siteid					AS [Site],
    mr.wonum					AS [Work Order],
    mrl.mrlinenum				AS [Item Line #],
    mrl.itemnum					AS [Item #],
    mrl.description				AS [Item Description],
    mrl.qty						AS [Quantity],
    mrl.unitcost				AS [Unit Cost],
    mrl.linecost				AS [Line Cost],
    wo.assignedownergroup		AS [Assigned Owner Group],
    wo.ownergroup				AS [Owner Group]
FROM dbo.mr AS mr
INNER JOIN dbo.mrline AS mrl
    ON  mrl.mrnum  = mr.mrnum
    AND mrl.siteid = mr.siteid     -- ensure same site
INNER JOIN dbo.workorder AS wo
    ON  wo.wonum  = mrl.refwo
    AND wo.siteid = mrl.siteid     -- ensure same site AS the line
WHERE
    mr.siteid = @SiteID
    AND mr.status NOT IN ('CAN', 'DRAFT')
    AND mr.enterdate  >= @StartOfPrevMonth
    AND mr.enterdate  <  @StartOfThisMonth
    AND (
        EXISTS (SELECT 1 FROM @Groups g WHERE g.GroupID = wo.assignedownergroup) OR
        EXISTS (SELECT 1 FROM @Groups g WHERE g.GroupID = wo.ownergroup)
    )
ORDER BY
    COALESCE(wo.assignedownergroup, wo.ownergroup) ASC,
    mr.requestedby ASC,
    mr.enterdate ASC;

