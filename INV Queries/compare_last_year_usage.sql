
-- Compare last year's recorded YTD usage with actual issue transactions and costs
-- Filters by site, item status, and issue type within the previous calendar year

SELECT DISTINCT
    inv.itemnum AS [Item],
    inv.issue1yrago AS [Last YEAR YTD],

    -- Sum of issue quantities from last year
    (
        SELECT SUM(quantity)
        FROM dbo.matusetrans
        WHERE itemnum = inv.itemnum
          AND issuetype = 'ISSUE'
          AND siteid = 'FWN'
          AND actualdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 2, 0)
          AND actualdate <  DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)
    ) AS [Last YEAR Issue Usage],

    -- Sum of issue costs from last year
    (
        SELECT SUM(linecost)
        FROM dbo.matusetrans
        WHERE itemnum = inv.itemnum
          AND issuetype = 'ISSUE'
          AND siteid = 'FWN'
          AND actualdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 2, 0)
          AND actualdate <  DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)
    ) AS [Last YEAR Cost]

FROM dbo.inventory AS inv
INNER JOIN dbo.matusetrans AS mat
    ON inv.itemnum = mat.itemnum
WHERE inv.siteid = 'FWN'
  AND inv.status != 'OBSOLETE'
  AND mat.issuetype = 'ISSUE'
  AND mat.actualdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 2, 0)
  AND mat.actualdate <  DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)
ORDER BY [Item];
