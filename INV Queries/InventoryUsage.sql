USE Max76PRD
GO


SELECT DISTINCT i.itemnum AS Item
	,i.binnum AS 'Default Bin'
	,abctype AS 'ABC Type'
	,status AS Status
	,ISNULL(CASE WHEN b.itemnum=b.itemnum THEN SUM(b.curbal )END, 0) AS 'Current Balalce'
	,minlevel AS 'Reorder Point'
	,orderqty AS 'Economic Reorder Quantity'
	,c.lastcost AS 'Last Receipt Cost'
	,issueytd AS 'Issued YTD'
	,issue1yrago AS 'Issued Last Year'
FROM dbo.inventory AS i
	LEFT JOIN dbo.invcost AS c
ON i.itemnum = c.itemnum AND i.siteid = c.siteid
	LEFT JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum AND i.siteid = b.siteid
WHERE i.siteid = 'FWN' AND status != 'OBSOLETE'
GROUP BY i.itemnum, i.binnum, abctype, status, b.itemnum, minlevel, orderqty, c.lastcost, issueytd, issue1yrago