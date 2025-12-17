USE max76PRD
GO

--Counts the active dbo.inventory items
SELECT COUNT(itemnum) AS 'Active Inventory Items'
FROM dbo.inventory
WHERE status NOT in ('INACTIVE','OBSOLETE') AND siteid='FWN' AND location = 'FWNCS';

--Counts all dbo.inventory items
SELECT COUNT(itemnum) AS 'Total Inventory'
FROM dbo.inventory
WHERE status NOT in ('OBSOLETE') AND siteid='FWN' AND location = 'FWNCS';

--Counts the number of transaction in CS
SELECT COUNT(invusenum) AS 'Transactions'
FROM dbo.invuse
WHERE status in ('COMPLETE','CLOSED') AND siteid = 'FWN'
	AND statusdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)
	AND statusdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)

--Counts the number of items issued for previous MONTH
SELECT SUM(quantity) AS 'Total Items Issued'
FROM dbo.invuseline
WHERE siteid = 'FWN'
	AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)
	AND actualdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0);

--Sums all line cost for all dbo.inventory usage record
SELECT FORMAT(SUM(linecost),'N','en-us') AS 'Issued Expense'
FROM dbo.invuseline
WHERE siteid = 'FWN'
	AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)
	AND actualdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0);

--Counts the number of returns FROM previous MONTH
SELECT COUNT(itemnum) AS 'Returns'
FROM dbo.inventory
WHERE (status NOT in ('OBSOLETE') AND siteid = 'FWN') 
	  AND (exists 
			(SELECT 1
			 FROM dbo.matusetrans 
			 WHERE (matusetrans.itemnum = inventory.itemnum AND matusetrans.storeloc = inventory.location 
				AND matusetrans.itemsetid = inventory.itemsetid AND matusetrans.siteid = inventory.siteid) 
				AND (issuetype= 'return' AND transdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) 
				AND transdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0))
		  	)
	  );

--Counts all items that have a physical COUNT date within the selected time
--WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
--		   FROM dbo.invbalances
--		   WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)
--		   GROUP BY itemnum)

SELECT COUNT(DISTINCT itemnum) AS 'Distinct Items'
FROM dbo.invtrans
WHERE siteid = 'FWN' AND transtype = 'RECBALADJ' AND transdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1, 0) 
	AND transdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) +0, 0)

SELECT COUNT(itemnum) AS 'Bins Counted'
FROM dbo.invtrans
WHERE siteid = 'FWN' AND transtype = 'RECBALADJ' AND transdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1, 0) 
	AND transdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) +0, 0);

WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
		   FROM dbo.invbalances
		   WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) 
		   GROUP BY itemnum)

SELECT COUNT(i.itemnum) AS 'Count Correct'
FROM dbo.invbalances AS i
	INNER JOIN b
		ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)
	AND i.physcnt = i.curbal;

--Counts items WHERE the physical COUNT is greater than the current balance 
WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
				    FROM dbo.invbalances
				    WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) 
				    GROUP BY itemnum)

SELECT COUNT(i.itemnum) AS 'Adjustment'
FROM dbo.invbalances AS i
	INNER JOIN b
		ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)
	AND i.physcnt > i.curbal;

--Counts items WHERE the physical COUNT is less than the current balance
WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
		   FROM dbo.invbalances
		   WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) 
		   GROUP BY itemnum)

SELECT COUNT(i.itemnum) AS 'Shrinkage'
FROM dbo.invbalances AS i
	INNER JOIN b
		ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)
	AND i.physcnt < i.curbal;

--Counts the number items WITH bin number AS TBD
SELECT COUNT(itemnum) AS 'TBD Bins'
FROM dbo.invbalances
WHERE binnum = 'TBD' AND siteid = 'FWN' AND location = 'FWNCS' AND curbal > 0;

--Find newly created item that have been assigned to FWNCS
SELECT COUNT(i.itemnum) AS 'New Items'
FROM dbo.inventory AS i
	INNER JOIN dbo.invstatus AS s
		ON i.itemnum = s.itemnum
WHERE i.itemsetid = 'IUS' AND i.status in ('ACTIVE','PLANNING') AND changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)
	AND i.location = 'FWNCS';

--Returns total value of active items
SELECT FORMAT(SUM(invcost.lastcost * invbalances.curbal), 'N', 'en-us') AS 'Total  for Active Items Only'
FROM dbo.invcost
	INNER JOIN dbo.invbalances
		ON invcost.itemnum = invbalances.itemnum
	INNER JOIN dbo.inventory
		ON dbo.inventory.itemnum = invcost.itemnum
WHERE invcost.location = 'FWNCS' AND invbalances.location = 'FWNCS' AND inventory.status NOT in ('INACTIVE', 'PENDOBS','OBSOLETE')
	AND dbo.inventory.location = 'FWNCS';

--Counts items WITH null OR zero value for last cost price for all item 
SELECT COUNT(c.itemnum) AS 'No Price for All Inventory'
FROM dbo.invcost AS c
	INNER JOIN dbo.inventory AS i 
		ON (c.itemnum = i.itemnum AND c.siteid = i.siteid AND c.location = i.location)
WHERE (lastcost = 0.00 OR lastcost is null) AND c.siteid = 'FWN' AND c.location = 'FWNCS' AND i.status <> 'OBSOLETE';

--Counts items WITH null OR zero value for last cost price for active items
SELECT COUNT(c.itemnum) AS 'No Active Price for Active Items Only'
FROM dbo.invcost AS c
	INNER JOIN dbo.inventory AS i	
		ON (i.itemnum = c.itemnum AND i.siteid = c.siteid)
WHERE c.location = 'FWNCS' AND i.location = 'FWNCS' AND i.status NOT in ('INACTIVE','PENDOBS','OBSOLETE') AND i.siteid = 'FWN'
	AND (c.lastcost = 0 OR c.lastcost is null);

--Sums total inventory
SELECT FORMAT(SUM(invcost.lastcost * invbalances.curbal),'N', 'en-us') AS 'Total Value for All Items in Inventory'
FROM dbo.invcost
	INNER JOIN dbo.invbalances
		ON invcost.itemnum = invbalances.itemnum
	INNER JOIN dbo.inventory
		ON inventory.itemnum = invcost.itemnum
WHERE invcost.location = 'FWNCS' AND invbalances.location = 'FWNCS' AND inventory.status NOT in ('OBSOLETE')
	AND dbo.inventory.location = 'FWNCS';

--Counts items that the last price paid is greater than 5 YEARs
SELECT COUNT(i.itemnum) AS 'Price Older than 5 YEARs'
FROM dbo.inventory AS i
	INNER JOIN dbo.invvendor AS v
		ON (i.itemnum = v.itemnum AND i.siteid = v.siteid)
WHERE  i.status NOT in ('OBSOLETE') AND i.siteid = 'FWN' AND  v.lastdate < DATEADD(YEAR, -5, GETDATE());

--Counts items that had price updated
SELECT COUNT(itemnum) AS 'Price Updated'
FROM dbo.invvendor
WHERE siteid = 'FWN' AND lastdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1, 0) AND lastdate < DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0)