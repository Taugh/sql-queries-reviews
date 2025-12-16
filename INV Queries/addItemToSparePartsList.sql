USE max76PRD
GO

SELECT v.itemnum
	,i.description
	,v.status
	,v.orderunit
	,v.issueunit
	,v.manufacturer
	,v.modelnum
	,v.binnum
FROM dbo.item AS i
	JOIN dbo.inventory AS v
ON i.itemnum = v.itemnum AND i.itemsetid = v.itemsetid
WHERE siteid = 'FWN' AND v.status != 'OBSOLETE' AND (sparepartautoadd is null OR sparepartautoadd = 0)
