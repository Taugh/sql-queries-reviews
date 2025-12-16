USE max76PRD
GO


SELECT DISTINCT p.ponum
	,l.itemnum
	,l.orderqty
	,p.siteid
	,p.orderdate
	,m.actualdate
	,leadtime = DATEDIFF(DAY,orderdate, actualdate)
FROM dbo.po AS p
	INNER JOIN dbo.poline AS l
ON p.ponum = l.ponum
	INNER JOIN dbo.matrectrans AS m
ON p.ponum = m.ponum AND l.itemnum = m.itemnum
WHERE p.siteid = 'FWN'AND orderdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-2, 0) AND l.itemnum = '121471'
	AND m.actualdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-2, 0)
ORDER BY l.itemnum, orderdate;
