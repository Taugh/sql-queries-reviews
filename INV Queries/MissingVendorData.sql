USE max76PRD
GO

SELECT v.itemnum
	,t.description
	,i.status
	,v.siteid
	,v.vendor
	,v.manufacturer
	,v.modelnum
	,v.catalogcode
	,v.isdefault
FROM dbo.invvendor AS v
	INNER JOIN dbo.inventory AS i
ON v.siteid = i.siteid AND v.itemnum = i.itemnum
	INNER JOIN dbo.item AS t
ON i.itemsetid = t.itemsetid AND i.itemnum = t.itemnum
WHERE v.siteid = 'FWN' AND i.status != 'OBSOLETE' AND (v.manufacturer is null OR v.modelnum is null OR v.catalogcode is null) 
	AND i.statusdate >=DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1,0)
ORDER BY v.itemnum
