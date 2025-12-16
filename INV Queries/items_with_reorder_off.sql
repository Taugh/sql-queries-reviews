
-- Find inventory items WITH reorder turned off
-- Includes item details, usage history, vendor info, AND asset associations
-- Uses a CTE to SELECT the latest vendor record per item AND site

WITH LatestVendor AS (
    SELECT 1
    FROM (
        SELECT 1,
               ROW_NUMBER() OVER (PARTITION BY itemnum, siteid ORDER BY lastdate DESC) AS rn
        FROM dbo.invvendor
    ) AS ranked
    WHERE rn = 1
)

SELECT DISTINCT
    inv.itemnum AS [Item #],
    it.description AS [Item Description],
    inv.status AS [Item Status],
    inv.gmpcritical AS [GMP Critical],
    inv.criticalspare AS [Critical Spare],
    ISNULL(inv.lastissuedate, '') AS [Last Issued],
    ISNULL(b.curbal, 0) AS [Current Balance],
    ISNULL(r.reservedqty, 0) AS [Reserved Quantity],
    COALESCE((b.curbal - r.reservedqty), b.curbal, 0) AS [Available Quantity],
    inv.issueytd AS [YTD Issue],
    inv.issue1yrago AS [Issued Last Year],
    inv.deliverytime AS [Lead Time (in days)],
    v.lastcost AS [Last Price Paid],
    v.lastdate AS [Last Price Date],
    sp.assetnum AS [WHERE Used],
    ISNULL(a.description, '') AS [Description],
    inv.glaccount AS [GL Account],
    c.accountname AS [GL Account Owner]
FROM dbo.inventory AS inv
INNER JOIN dbo.item AS it
    ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
LEFT JOIN dbo.invreserve AS r
    ON inv.itemnum = r.itemnum AND inv.location = r.location
LEFT JOIN dbo.invbalances AS b
    ON inv.itemnum = b.itemnum AND inv.location = b.location
LEFT JOIN dbo.sparepart AS sp
    ON inv.itemnum = sp.itemnum
INNER JOIN dbo.asset AS a
    ON sp.assetnum = a.assetnum
INNER JOIN dbo.chartofaccounts AS c
    ON inv.glaccount = c.glaccount
INNER JOIN LatestVendor AS v
    ON inv.itemnum = v.itemnum AND inv.siteid = v.siteid
WHERE it.itemsetid = 'IUS'
  AND inv.siteid = 'FWN'
  AND inv.location = 'FWNCS'
  AND inv.status NOT IN ('INACTIVE', 'PENDOBS', 'OBSOLETE')
  AND inv.reorder = 0
  AND a.siteid = 'FWN'
ORDER BY [GL Account Owner], [Item #];
