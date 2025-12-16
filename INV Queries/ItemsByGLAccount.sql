USE max76PRD
GO

SELECT i.itemnum
	,description
	,binnum
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
WHERE i.itemsetid = 'IUS' AND siteid = 'FWN' AND i.status = 'ACTIVE' AND glaccount = 'U3411M4213'