USE max76PRD
GO


SELECT DISTINCT i.itemnum AS 'Item'
	,t.description
	,c.company AS Manufacturer
	,v.modelnum AS Model
	,v.catalogcode AS Catalog 
	,i.orderunit AS 'Order Unit'
	,inv.glaccount AS 'GL Account'
	,eaudittimestamp
	,eauditusername
	,eaudittype
FROM dbo.a_inventory AS i
	INNER JOIN dbo.inventory AS inv
ON i.itemnum = inv.itemnum AND i.siteid = inv.siteid
	INNER JOIN dbo.item AS t
ON i.itemsetid = t.itemsetid AND i.itemnum = t.itemnum
	INNER JOIN dbo.invvendor AS v
ON i.itemnum = v.itemnum AND i.siteid = v.siteid
	INNER JOIN dbo.companies AS c
ON v.manufacturer = c.company
WHERE i.siteid = 'FWN' AND eaudittimestamp >= DATEADD(MONTH, DATEDIFF(MONTH,0, GETDATE())+0, 0) AND eaudittype = 'I'
ORDER BY 'Item';