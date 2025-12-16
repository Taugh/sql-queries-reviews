USE max76PRD
GO


SELECT p.ponum
	,MAX(polinenum) AS polines
	,p.revisionnum AS rev
FROM dbo.po AS p
	INNER JOIN dbo.poline AS l
ON p.ponum = l.ponum
	INNER JOIN (SELECT ponum, MAX(revisionnum) AS maxrev 
				FROM dbo.po 
				GROUP BY ponum) AS n
ON p.ponum = n.ponum AND p.revisionnum = n.maxrev
WHERE p.siteid = 'FWN' AND status = 'APPR' AND p.receipts = 'NONE' AND orderdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-4,0) 
	AND p.description NOT like'%MILLIPORE%'
GROUP BY p.ponum, p.revisionnum