USE max76PRD
GO

SELECT v.itemnum AS 'Item'
	,i.description AS 'Description'
	,v.abctype AS 'ABC Type'
	,v.status AS 'Status'
	,b.curbal AS 'Current Balence'
	,v.orderqty AS 'Order Quantity'
	,ISNULL(d.lastcost,'') AS 'Last Receipt Cost'
	,ISNULL(d.lastdate,'') AS 'Last Order Date', d.vendor AS 'Vendor'
FROM dbo.inventory AS v
	INNER JOIN dbo.item AS i
ON v.itemnum = i.itemnum AND v.itemsetid = i.itemsetid
	LEFT JOIN dbo.invvendor AS d
ON v.itemnum = d.itemnum AND v.siteid = d.siteid 
	INNER JOIN dbo.invbalances AS b
ON v.itemnum = b.itemnum AND v.location = b.location 
	INNER JOIN  (SELECT itemnum
					,MAX( lastdate) AS Mdate
				 FROM dbo.invvendor
				 GROUP BY itemnum
			    ) AS iv
ON d.itemnum = iv.itemnum
WHERE i.itemsetid = 'IUS' AND v.siteid = 'FWN' AND v.location = 'FWNCS'
	AND v.itemnum in ('100229','100235','100266','100268','100269','10027312')
	AND (d.lastdate = iv.Mdate AND d.isdefault = 1 OR (d.lastdate is null AND d.isdefault = 1))