USE max76PRD
GO


SELECT i.itemnum AS Item
	, t.description AS Description
	,i.binnum AS 'Default Bin'
	,i.abctype AS 'ABC Type'
	,i.status AS Status
	,b.curbal AS 'Current Balance'
	,i.minlevel AS 'Reorder Point'
	, i.orderqty AS 'Economic Order Qty'
	,i.issueytd AS 'Year to Date'
	,i.issue1yrago AS 'Last Year'
	,i.glaccount AS 'GL Account'
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
	INNER JOIN dbo.sparepart AS s
ON i.siteid = s.siteid AND i.itemnum = s.itemnum
	INNER JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum AND i.location = b.location
	INNER JOIN dbo.invvendor AS v
ON i.itemnum = v.itemnum AND i.siteid = v.siteid
WHERE i.siteid = 'FWN' AND s.assetnum in ('10331','10340','10490','10531','10594','10612','10667','10687','10735','10809','10855','10899','10900','10901','10902','10903','10904','10905','11044','12081','13734','14091','15101','15233','15272','15273','15284','18282','7346','7387','9620')
