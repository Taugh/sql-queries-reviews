USE max76PRD
GO

/******************************************************************************************
Query Name      : RequalListing.sql
File Path       : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\RQLQueries/RequalListing.sql
Rpository       : https://github.com/Taugh/sql-queries-reviews/tree/main/RQLQueries/RequalListing.sql
Author          : Troy Brannon
Date            : 2025-09-05
version         : 1.0

Purpose         : Returns all PMs AND associated work orders for assets starting WITH 'RQ',
                  including protocol numbers, completion dates, AND latest report dates.

Row Grain       : One row per asset-PM combination

Assumptions     : 
    - Assets of interest start WITH 'RQ'
    - Latest report date is used to identify most recent work order activity

Parameters      : None

Filters         : 
    - assetnum LIKE 'RQ%'
    - siteid = 'FWN'

Security        : No dynamic SQL OR user input. Safe for deployment.

Version Control : Staged for GitHub in 'sql-queries-reviews' repository.

Change Log      : 
    - 2025-09-05: Initial review AND header added by Copilot
******************************************************************************************/

WITH latest_reports AS (
    SELECT 
        wonum,
        MAX(reportdate) AS reportdate
    FROM dbo.workorder
    WHERE siteid = 'FWN'
    GROUP BY wonum
)

SELECT 
    a.assetnum AS [Asset Number],
    p.pmnum AS [PM Number],
    p.description AS [Description],
    p.status AS [PM Status],
    p.jpnum AS [Job Plan Number],
    p.ownergroup AS [Owner Group],
    MAX(w.wonum) AS [Work Order],
    a.eq2 AS [Protocol Number],
    p.lastcompdate AS [Last Completion Date],
    p.laststartdate AS [Complete Due Date],
    p.nextdate AS [Earliest Next Due Date],
    p.frequency AS [Frequency in Years]
FROM dbo.pm AS p
INNER JOIN dbo.asset AS a
    ON p.assetnum = a.assetnum AND p.siteid = a.siteid
INNER JOIN dbo.workorder AS w
    ON p.pmnum = w.pmnum AND p.siteid = w.siteid
INNER JOIN latest_reports AS rd
    ON w.wonum = rd.wonum AND w.reportdate = rd.reportdate
WHERE p.assetnum LIKE 'RQ%'
    AND p.siteid = 'FWN'
    AND p.pmnum = w.pmnum
    AND w.wonum = rd.wonum
GROUP BY 
    a.assetnum, p.pmnum, p.description, p.jpnum, p.ownergroup, a.eq2, 
    p.lastcompdate, p.laststartdate, p.nextdate, p.frequency, p.status
ORDER BY a.assetnum;
