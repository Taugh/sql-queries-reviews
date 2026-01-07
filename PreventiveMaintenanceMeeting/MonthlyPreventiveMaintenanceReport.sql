USE max76PRD

/*========================================================================================================================
 Query Name      : MonthlyMaintenanceMeetingReport.sql
 File Path       : /queries/pm_analysis/recent_pm_workorders_with_labor_and_inventory.sql

 Purpose         : Retrieves work orders FROM the past 6 months at site FWN that are NOT tasks AND 
  				   NOT of excluded work types, including associated labor hours AND inventory usage, 
				   to support analysis of resource utilization AND work execution trends.

 Row Grain       : One row per work order WITH associated labor AND inventory usage.

 Assumptions     : Only work orders WITH labor records are considered. Inventory usage is optional.

 Parameters      : None (static filter for siteid = 'FWN' AND last 6 months)

 Filters         : siteid = 'FWN', woclass IN ('WORKORDER','ACTIVITY'), istask = 0,
                   worktype NOT IN ('AD','CA','ECO','RM','PM','RQL','SDM'), reportdate in last 6 months

 Security        : No dynamic SQL OR user input. Safe for production.

 Version Control : https://github.com/Taugh/sql-queries-reviews/tree/main/Work%20Order%20Queries/MonthlyMaintenanceMeetingReport.sql

 Change Log      : 2023-09-08, Brannon, Troy – Initial review AND refactor
========================================================================================================================*/

SELECT 
    w.wonum,
    w.description,
    w.status,
    w.reportdate,
    w.worktype,
    w.assetnum,
    w.targcompdate,
    w.actstart,
    w.actfinish,
    w.assignedownergroup,
    l.regularhrs,
    l.laborcode,
    i.itemnum,
    i.description AS item_description,
    i.quantity
FROM dbo.workorder AS w
INNER JOIN dbo.labtrans AS l
    ON w.wonum = l.refwo 
    AND w.siteid = l.siteid
LEFT JOIN dbo.invuseline AS i
    ON w.wonum = i.refwo 
    AND w.siteid = i.tositeid
WHERE w.siteid = 'FWN'
  AND w.woclass IN ('WORKORDER','ACTIVITY')
  AND w.istask = 0
  AND w.worktype NOT IN ('AD','CA','DOCRV','ECO','RM','PM','RQL','SDM')
  -- Optional asset filter:
  -- AND w.assetnum IN ('3360','4023','6370','10109','10340','10992','13385','15314','15451','17281')
  AND w.reportdate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) - 6, 0)
  AND w.reportdate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0)
ORDER BY wonum;
