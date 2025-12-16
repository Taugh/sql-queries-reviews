USE max76PRD

/*
  =============================================
  Report: Central Stores Metrics
  Purpose: Monthly metrics for inventory, transactions, adjustments, AND valuation
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare reusable date variables for previous month
DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @EndDate   DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);

-- Declare temp table for latest physical count dates
DECLARE @LatestCounts TABLE (
    itemnum VARCHAR(50),
    maxdate DATETIME2
);

INSERT INTO @LatestCounts (itemnum, maxdate)
SELECT itemnum, MAX(physcntdate) AS maxdate
FROM dbo.invbalances
WHERE siteid = 'FWN' AND location = 'FWNCS' AND physcntdate >= @StartDate
GROUP BY itemnum;

-- Active Inventory Items
SELECT COUNT(itemnum) AS 'Active Inventory Items'
FROM dbo.inventory
WHERE status NOT IN ('INACTIVE','OBSOLETE') AND siteid = 'FWN' AND location = 'FWNCS';

-- Total Inventory Items
SELECT COUNT(itemnum) AS 'Total Inventory'
FROM dbo.inventory
WHERE status NOT IN ('OBSOLETE') AND siteid = 'FWN' AND location = 'FWNCS';

-- Transactions in Central Stores
SELECT COUNT(invusenum) AS 'Transactions'
FROM dbo.invuse
WHERE status IN ('COMPLETE','CLOSED') AND siteid = 'FWN'
  AND statusdate >= @StartDate AND statusdate < @EndDate;

-- Total Items Issued
SELECT SUM(quantity) AS 'Total Items Issued'
FROM dbo.invuseline
WHERE siteid = 'FWN'
  AND actualdate >= @StartDate AND actualdate < @EndDate;

-- Issued Expense
SELECT FORMAT(SUM(linecost), 'N', 'en-us') AS 'Issued Expense'
FROM dbo.invuseline
WHERE siteid = 'FWN'
  AND actualdate >= @StartDate AND actualdate < @EndDate;

-- Returns
SELECT COUNT(itemnum) AS 'Returns'
FROM dbo.inventory
WHERE status NOT IN ('OBSOLETE') AND siteid = 'FWN'
  AND EXISTS (
      SELECT 1
      FROM dbo.matusetrans
      WHERE matusetrans.itemnum = inventory.itemnum
        AND matusetrans.storeloc = inventory.location
        AND matusetrans.itemsetid = inventory.itemsetid
        AND matusetrans.siteid = inventory.siteid
        AND issuetype = 'return'
        AND transdate >= @StartDate AND transdate < @EndDate
  );

-- Distinct Items Counted
SELECT COUNT(DISTINCT itemnum) AS 'Distinct Items'
FROM dbo.invtrans
WHERE siteid = 'FWN' AND transtype = 'RECBALADJ'
  AND transdate >= @StartDate AND transdate < @EndDate;

-- Bins Counted
SELECT COUNT(itemnum) AS 'Bins Counted'
FROM dbo.invtrans
WHERE siteid = 'FWN' AND transtype = 'RECBALADJ'
  AND transdate >= @StartDate AND transdate < @EndDate;

-- Count Correct
SELECT COUNT(i.itemnum) AS 'Count Correct'
FROM dbo.invbalances AS i
  INNER JOIN @LatestCounts AS b 
ON i.itemnum = b.itemnum AND i.physcntdate = b.maxdate
WHERE i.physcntdate >= @StartDate AND i.physcntdate < @EndDate
  AND i.physcnt = i.curbal;

-- Adjustment (physcnt > curbal)
SELECT COUNT(i.itemnum) AS 'Adjustment'
FROM dbo.invbalances AS i
  INNER JOIN @LatestCounts AS b 
ON i.itemnum = b.itemnum AND i.physcntdate = b.maxdate
WHERE i.physcntdate >= @StartDate AND i.physcntdate < @EndDate
  AND i.physcnt > i.curbal;

-- Shrinkage (physcnt < curbal)
SELECT COUNT(i.itemnum) AS 'Shrinkage'
FROM dbo.invbalances AS i
  INNER JOIN @LatestCounts AS b 
ON i.itemnum = b.itemnum AND i.physcntdate = b.maxdate
WHERE i.physcntdate >= @StartDate AND i.physcntdate < @EndDate
  AND i.physcnt < i.curbal;

-- TBD Bins
SELECT COUNT(itemnum) AS 'TBD Bins'
FROM dbo.invbalances
WHERE binnum = 'TBD' AND siteid = 'FWN' AND location = 'FWNCS' AND curbal > 0;

-- New Items Assigned to FWNCS
SELECT COUNT(i.itemnum) AS 'New Items'
FROM dbo.inventory AS i
  INNER JOIN dbo.invstatus AS s 
ON i.itemnum = s.itemnum
WHERE i.itemsetid = 'IUS' AND i.status IN ('ACTIVE','PLANNING')
  AND i.location = 'FWNCS'
  AND s.changedate >= @StartDate;

-- Total Value for Active Items
SELECT FORMAT(SUM(invcost.lastcost * invbalances.curbal), 'N', 'en-us') AS 'Total for Active Items Only'
FROM dbo.invcost
  INNER JOIN dbo.invbalances 
ON invcost.itemnum = invbalances.itemnum
  INNER JOIN dbo.inventory 
ON dbo.inventory.itemnum = invcost.itemnum
WHERE invcost.location = 'FWNCS' AND invbalances.location = 'FWNCS'
  AND inventory.status NOT IN ('INACTIVE', 'PENDOBS', 'OBSOLETE')
  AND inventory.location = 'FWNCS';

-- No Price for All Inventory
SELECT COUNT(c.itemnum) AS 'No Price for All Inventory'
FROM dbo.invcost AS c
  INNER JOIN dbo.inventory AS i 
ON c.itemnum = i.itemnum AND c.siteid = i.siteid AND c.location = i.location
WHERE (c.lastcost = 0 OR c.lastcost IS NULL)
  AND c.siteid = 'FWN' AND c.location = 'FWNCS'
  AND i.status <> 'OBSOLETE';

-- No Price for Active Items
SELECT COUNT(c.itemnum) AS 'No Active Price for Active Items Only'
FROM dbo.invcost AS c
  INNER JOIN dbo.inventory AS i 
ON i.itemnum = c.itemnum AND i.siteid = c.siteid
WHERE c.location = 'FWNCS' AND i.location = 'FWNCS'
  AND i.status NOT IN ('INACTIVE','PENDOBS','OBSOLETE') AND i.siteid = 'FWN'
  AND (c.lastcost = 0 OR c.lastcost IS NULL);

-- Total Value for All Items
SELECT FORMAT(SUM(invcost.lastcost * invbalances.curbal), 'N', 'en-us') AS 'Total Value for All Items in Inventory'
FROM dbo.invcost
  INNER JOIN dbo.invbalances 
ON invcost.itemnum = invbalances.itemnum
  INNER JOIN dbo.inventory 
ON dbo.inventory.itemnum = invcost.itemnum
WHERE invcost.location = 'FWNCS' AND invbalances.location = 'FWNCS'
  AND inventory.status NOT IN ('OBSOLETE') AND inventory.location = 'FWNCS';

-- Price Older than 5 Years
SELECT COUNT(i.itemnum) AS 'Price Older than 5 Years'
FROM dbo.inventory AS i
  INNER JOIN dbo.invvendor AS v 
ON i.itemnum = v.itemnum AND i.siteid = v.siteid
WHERE i.status NOT IN ('OBSOLETE') AND i.siteid = 'FWN'
  AND v.lastdate < DATEADD(YEAR, -5, GETDATE());

-- Price Updated
SELECT COUNT(itemnum) AS 'Price Updated'
FROM dbo.invvendor
WHERE siteid = 'FWN'
  AND lastdate >= @StartDate AND lastdate < @EndDate;
