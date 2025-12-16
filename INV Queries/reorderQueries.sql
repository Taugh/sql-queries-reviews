USE max76PRD
GO

SELECT itemnum
FROM dbo.inventory
WHERE (status NOT in ('INACTIVE','OBSOLETE') AND siteid = 'FWN' AND reorder = 1)
	AND (exists (SELECT 1 FROM dbo.invreserve WHERE itemnum = inventory.itemnum AND location = inventory.location AND itemsetid = inventory.itemsetid 
	AND siteid = inventory.siteid AND (inventory.minlevel + 1) >=  (SELECT curbal FROM dbo.invbalances WHERE itemnum = inventory.itemnum AND siteid = inventory.siteid 
	AND binnum = inventory.binnum)  - reservedqty))
	AND (exists (SELECT 1 FROM dbo.item WHERE (us2_controlled = 0) AND (itemnum = inventory.itemnum AND itemsetid = inventory.itemsetid)))
ORDER BY itemnum;


SELECT i.itemnum
	,t.description
	,b.curbal
	,r.reservedqty
			,i.minlevel
FROM	dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemsetid = t.itemsetid AND i.itemnum = t.itemnum
	LEFT JOIN dbo.invreserve AS r
ON i.itemnum = r.itemnum AND i.siteid = r.siteid AND i.location = r.location AND i.itemsetid = r.itemsetid
	LEFT JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum AND i.siteid = b.siteid AND i.binnum = b.binnum
WHERE i.itemsetid = 'IUS' AND i.siteid = 'FWN' AND i.location = 'FWNCS' AND i.status NOT in ('INACTIVE','OBSOLETE') AND i.reorder = 1
	AND b.curbal - r.reservedqty <= (i.minlevel +1) AND t.us2_controlled = 0
ORDER BY i.itemnum;