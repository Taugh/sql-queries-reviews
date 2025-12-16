USE max76PRD
GO


SELECT i.itemnum
	,eaudittimestamp
	,eaudittype
	,eauditusername
	,o.status AS 'item/org status'
FROM dbo.a_item AS i
	INNER JOIN dbo.itemorginfo AS o
ON i.itemnum = o.itemnum
	INNER JOIN dbo.inventory AS v
ON i.itemnum = v.itemnum AND i.itemsetid = v.itemsetid
WHERE i.itemsetid = 'IUS' 
	AND eaudittimestamp >= DATEADD(YEAR, datediff(YEAR,0,CURRENT_TIMESTAMP)+0,0) 
	AND eaudittype = 'I' 
	AND i.itemnum NOT LIKE '%A'
	AND location = 'FWNCS'
	AND eauditusername IN ('BRANNTR1') 
	AND v.status != 'OBSOLETE'
ORDER BY eaudittimestamp