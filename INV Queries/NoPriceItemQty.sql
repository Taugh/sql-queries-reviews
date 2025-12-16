USE max76PRD
GO

-- Returns curbal for all active items WHERE the last cost is either null OR 0
SELECT DISTINCT i.itemnum
	,t.description
	,b.curbal
	,i.issueunit
	,i.orderunit
FROM dbo.invcost AS c
	INNER JOIN dbo.inventory AS i	
ON (i.itemnum = c.itemnum AND i.siteid = c.siteid)
	INNER JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
WHERE c.location = 'FWNCS' AND i.location = 'FWNCS' AND i.status NOT in ('INACTIVE','PENDOBS','OBSOLETE') AND i.siteid = 'FWN'
	AND (c.lastcost = 0 OR c.lastcost is null);

-- Returns curbal for all inactive items WHERE the last cost is null OR zero
SELECT DISTINCT i.itemnum
	,t.description
	,b.curbal
	,i.issueunit
	,i.orderunit
FROM dbo.invcost AS c
	INNER JOIN dbo.inventory AS i 
ON (c.itemnum = i.itemnum AND c.siteid = i.siteid AND c.location = i.location)
	INNER JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
WHERE (lastcost = 0.00 OR lastcost is null) AND c.siteid = 'FWN' AND c.location = 'FWNCS' AND i.status NOT in ('ACTIVE','OBSOLETE')