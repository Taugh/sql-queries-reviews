USE max76PRD
GO

--Returns items AND the assigned GL
SELECT inv.itemnum AS 'Item'
	,i.description AS 'Description'
	,inv.status AS 'Status'
	,inv.glaccount AS 'GL Account'
FROM dbo.inventory AS inv
	INNER JOIN dbo.item AS i
ON inv.itemnum = i.itemnum
WHERE inv.location = 'FWNCS' AND i.itemsetid = 'IUS' AND inv.status != 'OBSOLETE' AND inv.itemnum NOT like 'Z%'
	AND inv.itemnum NOT in ('TESTITEM','SPOTBUY')
