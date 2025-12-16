USE max76PRD
GO

SELECT DISTINCT i.itemnum AS Item
	,t.description AS 'Description'
	,t.itemsetid AS Itemset
	,i.siteid AS 'Site'
	,i.location AS Storeroom
	,i.status AS 'Status'
	,curbal AS Balance
	,i.binnum AS 'Default Bin'
	,b.binnum AS 'Additional Bin'
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum 
	INNER JOIN dbo.invbalances AS b
ON (i.itemnum = b.itemnum AND i.siteid = b.siteid)
WHERE i.siteid = 'FWN' AND t.itemsetid = 'IUS' AND i.location = 'FWNCS' AND i.status = 'ACTIVE'
	AND i.status <> 'OBSOLETE' /*AND i.binnum <>b.binnum*/  AND (i.binnum = 'TBD' OR b.binnum = 'TBD')
	AND curbal > 0
ORDER BY Item;