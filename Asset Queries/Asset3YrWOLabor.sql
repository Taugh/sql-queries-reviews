USE max76PRD
GO

-- Purpose: Summarize unscheduled labor hours AND work order counts per asset
--          for the past 3 years (2022–2024) at site 'FWN' for specific owner groups.
-- Notes:
--   - Filters for CM worktype AND excludes tasks.
--   - Groups by asset number AND description.

SELECT 
    w.assetnum, -- Asset identifier
    a.description, -- Asset description
    
    -- 2022
    SUM(CASE 
        WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 3, 0) 
         AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 2, 0)
        THEN 1 ELSE 0 
    END) AS [2022 Work Orders],
    
    SUM(CASE 
        WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 3, 0) 
         AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 2, 0)
        THEN w.actlabhrs ELSE 0 
    END) AS [2022 Charged Labor],

    -- 2023
    SUM(CASE 
        WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 2, 0) 
         AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0)
        THEN 1 ELSE 0 
    END) AS [2023 Work Orders],
    
    SUM(CASE 
        WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 2, 0) 
         AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0)
        THEN w.actlabhrs ELSE 0 
    END) AS [2023 Charged Labor],

    -- 2024
    SUM(CASE 
        WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0) 
         AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)
        THEN 1 ELSE 0 
    END) AS [2024 Work Orders],
    
    SUM(CASE 
        WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0) 
         AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)
        THEN w.actlabhrs ELSE 0 
    END) AS [2024 Charged Labor]

FROM dbo.workorder AS w
INNER JOIN dbo.asset AS a
    ON w.siteid = a.siteid AND w.assetnum = a.assetnum
WHERE 
    w.woclass IN ('WORKORDER', 'ACTIVITY') 
    AND w.istask = 0 
    AND w.siteid = 'FWN' 
    AND w.worktype = 'CM' 
    AND w.assignedownergroup IN ('FWNCSM', 'FWNMET', 'FWNWSM')
    AND reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 3, 0) 
    AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)
GROUP BY 
    w.assetnum, a.description