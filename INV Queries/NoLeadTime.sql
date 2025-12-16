USE max76PRD
GO


SELECT itemnum
	,DATEDIFF(DAY,p.orderdate,actualdate) AS leadtime
FROM dbo.matrectrans AS m
	INNER JOIN dbo.po AS p
ON m.ponum = p.ponum AND m.siteid = p.siteid
WHERE m.siteid = 'FWN' --AND itemnum in ('')

