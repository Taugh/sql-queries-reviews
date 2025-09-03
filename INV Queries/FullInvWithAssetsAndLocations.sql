-- Purpose: Retrieve full active inventory with bin locations, pricing, usage, and account ownership
-- Notes:
--   - Filters for active items in FWNCS storeroom
--   - Uses CTE to get latest vendor pricing
--   - Includes spare part usage and GL account ownership

;WITH LatestVendor AS (
    SELECT *
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY itemnum, siteid ORDER BY lastdate DESC) AS rn
        FROM invvendor
    ) AS ranked
    WHERE rn = 1
)

SELECT DISTINCT 
    inv.itemnum AS [Item #],
    it.description AS [Item Description],
    inv.status AS [Item Status],
    inv.binnum AS [Bin Number],
    b.binnum AS [Alternate Bin],
    inv.gmpcritical AS [GMP Critical],
    inv.criticalspare AS [Critical Spare],
    ISNULL(CONVERT(varchar(10), inv.lastissuedate, 120), '') AS [Last Issued],
    ISNULL(b.curbal, 0) AS [Current Balance],
    ISNULL(r.reservedqty, 0) AS [Reserved Quantity],
    COALESCE(b.curbal - r.reservedqty, b.curbal, 0) AS [Available Quantity],
    inv.issueytd AS [YTD Issue],
    inv.issue1yrago AS [Issued Last Year],
    inv.deliverytime AS [Lead Time (in days)],
    v.lastcost AS [Last Price Paid],
    v.lastdate AS [Last Price Date],
    sp.assetnum AS [Where Used],
    ISNULL(a.description, '') AS [Asset Description],
    inv.glaccount AS [GL Account],
    c.accountname AS [GL Account Owner]
FROM inventory AS inv
INNER JOIN item AS it
    ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
LEFT JOIN invreserve AS r
    ON inv.itemnum = r.itemnum AND inv.location = r.location
LEFT JOIN invbalances AS b
    ON inv.itemnum = b.itemnum AND inv.location = b.location
LEFT JOIN sparepart AS sp
    ON inv.itemnum = sp.itemnum
LEFT JOIN asset AS a
    ON sp.assetnum = a.assetnum AND a.siteid = 'FWN'
LEFT JOIN chartofaccounts AS c
    ON inv.glaccount = c.glaccount
LEFT JOIN LatestVendor AS v
    ON inv.itemnum = v.itemnum AND inv.siteid = v.siteid
WHERE 
    it.itemsetid = 'IUS'
    AND inv.siteid = 'FWN'
    AND inv.location = 'FWNCS'
    AND inv.status NOT IN ('OBSOLETE')
ORDER BY [Item #];