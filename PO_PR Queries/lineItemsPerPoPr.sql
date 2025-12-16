USE max76PRD
GO


SELECT Distinct p.prnum
	,MAX(l.prlinenum) AS PRLINES
	--,MAX(p.revisionnum)
FROM dbo.pr AS p
	INNER JOIN dbo.prline AS l
ON p.prnum = l.prnum --AND p.revisionnum = l.revisionnum
WHERE p.siteid = 'FWN' 
	AND issuedate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) -2, +0) 
	AND l.ponum is null 
	AND p.status in ('WAPPR','APPR')
GROUP BY p.prnum
ORDER BY p.prnum
