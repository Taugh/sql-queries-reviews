USE max76PRD
GO

-- Purpose: Retrieve inventory used on CM work orders within the last 6 months
-- Notes:
--   - Filters by site, work type, and actual date range
--   - Includes item cost and total cost calculation

SELECT 
    m.itemnum,
    m.description,
    m.assetnum,
    m.storeloc,
    m.transdate,
    m.quantity,
    v.lastcost,
    ABS(m.quantity * v.lastcost) AS Total,
    w.wonum,
    w.worktype
FROM matusetrans AS m
INNER JOIN invvendor AS v
    ON m.itemnum = v.itemnum AND m.siteid = v.siteid
INNER JOIN workorder AS w
    ON m.siteid = w.siteid AND m.refwo = w.wonum
WHERE 
    m.siteid = 'FWN'
    AND w.worktype = 'CM'
    AND m.actualdate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) - 5, 0)
    AND m.actualdate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) + 1, 0)
    AND v.isdefault = '1'
    AND w.woclass IN ('WORKORDER', 'ACTIVITY')
    AND w.istask = 0
ORDER BY w.wonum;