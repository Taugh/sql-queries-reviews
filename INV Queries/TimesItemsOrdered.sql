USE max76PRD
GO

--Current years high reordered items
SELECT l.itemnum AS 'Item'
	,i.description AS Description
	,COUNT(l.itemnum) AS 'Times Reordered'
	,SUM(l.orderqty) AS 'Total Ordered'
FROM dbo.poline AS l
	INNER JOIN dbo.po AS p
ON l.ponum = p.ponum AND l.revisionnum = p.revisionnum
	INNER JOIN dbo.item AS i
ON l.itemnum = i.itemnum
WHERE p.siteid = 'FWN' AND i.itemsetid = 'IUS' AND l.enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0) AND l.storeloc = 'FWNCS'
	AND p.status NOT in ('CAN','REVISD')
GROUP BY l.itemnum, i.description
HAVING COUNT(l.itemnum) > 4
ORDER BY 'Times Reordered' desc, 'Item';

--Previous years high reordered items
SELECT l.itemnum AS 'Item'
	,i.description AS Description
	,v.glaccount AS 'GL Account'
	,c.accountname AS 'Account Owner'
	,COUNT(l.itemnum) AS 'Times Reordered'
	,SUM(l.orderqty) AS 'Total Ordered'
FROM dbo.poline AS l
	INNER JOIN dbo.po AS p
ON l.ponum = p.ponum AND l.revisionnum = p.revisionnum
	INNER JOIN dbo.item AS i
ON l.itemnum = i.itemnum
	INNER JOIN dbo.inventory AS v
ON i.itemnum = v.itemnum
	INNER JOIN dbo.chartofaccounts AS c
ON v.glaccount = c.glaccount
WHERE p.siteid = 'FWN' AND i.itemsetid = 'IUS' AND l.enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-12,+0) 
	AND l.enterdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0) AND l.storeloc = 'FWNCS'
	AND p.status NOT in ('CAN','REVISD') AND v.glaccount like 'U%' AND v.siteid = 'FWN'
GROUP BY l.itemnum, i.description, v.glaccount, c.accountname
HAVING COUNT(l.itemnum) > 4
ORDER BY 'Times Reordered' desc, 'Item';