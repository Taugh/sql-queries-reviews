USE max76PRD
GO


SELECT p.ponum AS PO
	,p.siteid AS Site
	,p.description AS Description
	,p.status AS Status
	,MAX(p.revisionnum) AS Revision
	,l.polinenum AS Lines
	,linetype AS 'Line Type'
	,l.itemnum AS Item
	,l.description AS Description
	,l.orderqty AS Quantity
	,l.orderunit AS 'Order Unit'
	,l.manufacturer AS Manufacturer
	,l.modelnum AS Model
	,i.glaccount AS 'GL Debit Account'
FROM dbo.poline AS l
	JOIN dbo.po AS p
ON p.ponum = l.ponum
	JOIN dbo.inventory AS i
ON l.itemnum = i.itemnum AND l.siteid = i.siteid AND l.orgid = p.orgid
WHERE p.siteid in ('ASPEX','FWN') AND l.itemsetid = 'IUS' AND p.ponum = '45458' AND p.status = 'APPR' 
GROUP BY p.ponum, p.siteid, p.description, p.status, l.polinenum, linetype, l.itemnum, l.description,
	l.orderqty, l.orderunit, l.manufacturer, l.modelnum, i.glaccount;

