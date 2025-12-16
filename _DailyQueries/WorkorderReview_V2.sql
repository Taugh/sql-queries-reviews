USE max76PRD
GO

/*****************************************************************************************

Query Name: WO_Review_Flags_PendingReview.sql
Location / File Path: sql/work_orders/WO_Review_Flags_PendingReview.sql

Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0

Purpose:
  Identify pending review work orders at site FWN that:
  - Started early OR finished late.
  - Have no labor transactions.
  - Have no worklog entries.
  - Have NOT received QA Approval.

Row Grain:
  One row per flagged work order (WORKORDER).


Assumptions:
  - Work orders are filtered by status 'PENRVW', site 'FWN', AND org 'US'.
  - QA Approval is tracked via WORKLOG.LOGTYPE = 'QA APPROVAL'.
  - Labor is tracked via LABTRANS linked to WORKORDER via REFWO OR child tasks.
  - Log presence is determined by existence of WORKLOG entries.

Parameters:

Filters:
  - Work orders must be active (NOT history), NOT tasks, AND of class WORKORDER OR ACTIVITY.
  - QA Approval required for all flagged conditions.

Security:
  - Read-only; no sensitive columns.

Version Control:
  - Store under /sql/work_orders WITH a paired doc under /docs/work_orders.

Change Log:
  2025-09-05  TB/M365  Refactor for clarity & performance: modular CTEs, QA filter, UNION ALL,
                       qualified columns, consistent casing, standardized header.
*****************************************************************************************/

DECLARE @site1 VARCHAR(3) = 'FWN';
DECLARE @site2 VARCHAR(5) = 'ASPEX';
DECLARE @active_site VARCHAR(5) = @site1;  -- change site here


WITH base_workorders AS (
    SELECT wonum, siteid, status, worktype, assignedownergroup, owner,
           targcompdate, fnlconstraint, actfinish, actstart, sneconstraint
    FROM dbo.workorder
    WHERE orgid = 'US'
      AND siteid = @active_site
      AND status = 'PENRVW'
      AND woclass IN ('WORKORDER', 'ACTIVITY')
      AND istask = 0
      AND worktype IN ('CA', 'PM', 'RM', 'RQL')
),

qa_missing AS (
    SELECT recordkey, siteid
    FROM dbo.worklog
    WHERE logtype = 'QA APPROVAL' OR description = 'QA Approved'
),

not_ontime AS (
    SELECT b.*
    FROM base_workorders b
    WHERE (b.actfinish > b.fnlconstraint OR 
          (b.actstart < b.sneconstraint AND b.targcompdate > {ts '2024-03-01 00:00:00.000'}))
      AND NOT EXISTS (
          SELECT 1
          FROM qa_missing q
          WHERE q.siteid = b.siteid AND q.recordkey = b.wonum
      )
),

no_labor AS (
    SELECT w.wonum, w.siteid, w.status, w.worktype, w.assignedownergroup, w.owner,
           w.targcompdate, w.fnlconstraint, w.actfinish
    FROM dbo.workorder w
    WHERE w.siteid = @active_site
      AND w.status = 'PENRVW'
      AND w.woclass IN ('WORKORDER', 'ACTIVITY')
      AND w.historyflag = 0
      AND w.istask = 0
      AND w.worktype != 'AD'
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.labtrans l
			INNER JOIN dbo.workorder w1 
		  ON l.siteid = w1.siteid AND l.refwo = w1.wonum
          WHERE l.siteid = w.siteid AND (l.refwo = w.wonum OR (w1.parent = w.wonum AND w1.istask = 1))
      )
      AND NOT EXISTS (
          SELECT 1
          FROM qa_missing q
          WHERE q.siteid = w.siteid AND q.recordkey = w.wonum
      )
),

no_log AS (
    SELECT w.wonum, w.siteid, w.status, w.worktype, w.assignedownergroup, w.owner,
           w.targcompdate, w.fnlconstraint, w.actfinish
    FROM dbo.workorder w
    WHERE w.siteid = @active_site
      AND w.status = 'PENRVW'
      AND w.woclass IN ('WORKORDER', 'ACTIVITY')
      AND w.historyflag = 0
      AND w.istask = 0
      AND w.worktype != 'AD'
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.worklog wl
          WHERE wl.siteid = w.siteid AND wl.recordkey = w.wonum
      )
)

-- Final UNION of all flagged work orders
SELECT wonum, siteid, status, worktype, assignedownergroup, owner,
       targcompdate, fnlconstraint, actfinish,
       CASE 
           WHEN actstart < sneconstraint AND targcompdate > {ts '2024-03-01 00:00:00.000'} THEN 'Started Early'
           WHEN actfinish > fnlconstraint THEN 'Late'
           ELSE ''
       END AS Error
FROM not_ontime

UNION ALL

SELECT wonum, siteid, status, worktype, assignedownergroup, owner,
       targcompdate, fnlconstraint, actfinish,
       'No Labor' AS Error
FROM no_labor

UNION ALL

SELECT wonum, siteid, status, worktype, assignedownergroup, owner,
       targcompdate, fnlconstraint, actfinish,
       'No Log' AS Error
FROM no_log;


-- Summary count of all pending review work orders
SELECT COUNT(wonum) AS total_pending_review
FROM dbo.workorder
WHERE siteid = @active_site
  AND status = 'PENRVW'
  AND woclass IN ('WORKORDER', 'ACTIVITY')
  AND historyflag = 0
  AND istask = 0;
