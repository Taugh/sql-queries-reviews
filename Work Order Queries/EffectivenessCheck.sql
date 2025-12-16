USE max76PRD
GO

/* ============================================================================
Query Name       : Closed Corrective Work Orders - Last 6 Months
File Path        : sql-queries-reviews/work_orders/closed_corrective_workorders_6mo.sql
Purpose          : Retrieves closed corrective work orders FROM the past 6 months at site FWN.
Row Grain        : One row per closed work order
Assumptions      : actfinish is populated for closed work orders; istask = 0 filters out sub-tasks
Parameters       : None
Filters          : siteid = 'FWN', status = 'CLOSE', actfinish >= 6 months ago, woclass IN ('WORKORDER','ACTIVITY'), istask = 0, worktype = 'CM'
Security         : Ensure access to workorder table is restricted to authorized users
Change Log       : 2025-09-08, Brannon, Troy – Initial review AND refactor
============================================================================ */

SELECT 
    wonum,
    description,
    assetnum,
    status,
    actfinish
FROM dbo.workorder
WHERE 
    siteid = 'FWN'
    AND status = 'CLOSE'
    AND actfinish >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 6, 0)
    AND woclass IN ('WORKORDER', 'ACTIVITY')
    AND istask = 0
    AND worktype = 'CM';
