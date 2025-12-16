USE max76PRD
GO 


SELECT p.prnum AS PR
	,CONVERT(varchar(10),p.issuedate,20) AS 'Order Date'
	,l.prlinenum AS Line
	,l.itemnum AS Item
	,l.description AS Description
	,l.ponum AS 'PO Number'
	,i.status AS 'Item Status'
	,i.glaccount AS 'GL Account'
	,c.accountname AS 'Account Owner'
FROM dbo.pr AS p
	INNER JOIN dbo.prline AS l
ON p.prnum = l.prnum AND p.siteid = l.siteid
	INNER JOIN dbo.inventory AS i
ON l.itemnum = i.itemnum AND p.siteid = i.siteid
	INNER JOIN dbo.chartofaccounts AS c
ON i.glaccount = c.glaccount
WHERE p.siteid ='ASPEX' AND l.ponum is null AND p.status in ('WAPPR','APPR') AND p.prnum in ('56310','56745') AND l.ponum is null
ORDER BY 'Line', PR;