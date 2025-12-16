USE max76PRD

-- Retrieve items used ON specific assets that are NOT listed AS spare parts
-- Filters by site, location, inventory status, AND default flag
-- Uses NOT EXISTS for better performance AND null safety

SELECT DISTINCT
    s.assetnum AS Asset,
    a.status AS AssetStatus,
    s.itemnum AS Item,
    it.description AS Description,
    i.status AS INVStatus,
    i.glaccount AS GLAccount,
    c.accountname AS AccountOwner,
    i.binnum AS Bin,
    i.manufacturer AS Manufacturer,
    i.modelnum AS ModelNumber,
    i.orderunit AS OrderUnit,
    b.curbal AS CurrentBalance,
    i.issueytd AS YTD_Usage,
    i.issue1yrago AS Issued_Last_Year,
    i.issue2yrago AS Issued_2_Yr_Ago,
    i.issue3yrago AS Issued_3_Yr_Ago,
    v.lastcost AS Last_Price
FROM dbo.sparepart AS s
INNER JOIN dbo.inventory AS i
    ON s.itemnum = i.itemnum AND s.siteid = i.siteid
INNER JOIN dbo.item AS it
    ON i.itemnum = it.itemnum AND i.itemsetid = it.itemsetid
INNER JOIN dbo.asset AS a
    ON s.assetnum = a.assetnum AND s.siteid = a.siteid
INNER JOIN dbo.chartofaccounts AS c
    ON i.glaccount = c.glaccount
INNER JOIN dbo.invbalances AS b
    ON i.itemsetid = b.itemsetid
    AND i.siteid = b.siteid
    AND i.location = b.location
    AND i.itemnum = b.itemnum
INNER JOIN dbo.invvendor AS v
    ON i.itemnum = v.itemnum AND i.siteid = v.siteid
WHERE s.siteid = 'FWN'
  AND it.itemsetid = 'IUS'
  AND i.location = 'FWNCS'
  AND s.assetnum IN ('')  -- TODO: Replace WITH actual asset numbers
  AND i.status = 'ACTIVE'
  AND isdefault = 1
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.sparepart sp
      WHERE sp.siteid = 'FWN'
        AND sp.assetnum = s.assetnum
        AND sp.itemnum = s.itemnum
  )
ORDER BY Asset, Item;
