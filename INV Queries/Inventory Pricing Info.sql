USE max76PRD
GO


--Returns total value of active items
SELECT FORMAT(SUM(invcost.lastcost * invbalances.curbal), 'N', 'en-us') AS 'Total  for Active Items Only'
FROM dbo.invcost
	INNER JOIN dbo.invbalances
ON invcost.itemnum = invbalances.itemnum
	INNER JOIN dbo.inventory
ON dbo.inventory.itemnum = invcost.itemnum
WHERE invcost.location = 'FWNCS' AND invbalances.location = 'FWNCS' AND inventory.status NOT in ('INACTIVE', 'PENDOBS','OBSOLETE')
	AND dbo.inventory.location = 'FWNCS';

--Sums total inventory
SELECT FORMAT(SUM(invcost.lastcost * invbalances.curbal),'N', 'en-us') AS 'Total Value for All Items in Inventory'
FROM dbo.invcost
	INNER JOIN dbo.invbalances
ON invcost.itemnum = invbalances.itemnum
	INNER JOIN dbo.inventory
ON dbo.inventory.itemnum = invcost.itemnum
WHERE invcost.location = 'FWNCS' AND invbalances.location = 'FWNCS' AND inventory.status NOT in ('OBSOLETE')
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

--Counts items that the last price paid is greater than 5 YEARs
SELECT COUNT(i.itemnum) AS 'Price Older than 5 YEARs'
FROM dbo.inventory AS i
	JOIN dbo.invvendor AS v
ON (i.itemnum = v.itemnum AND i.siteid = v.siteid)
WHERE  i.status NOT in ('OBSOLETE') AND i.siteid = 'FWN' AND  v.lastdate < DATEADD(YEAR, -5, GETDATE());