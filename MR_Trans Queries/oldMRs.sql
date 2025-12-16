USE max76PRD
GO


SELECT DISTINCT *
FROM dbo.mr AS m
	INNER JOIN dbo.mrstatus AS s
ON m.mrnum = s.mrnum
	INNER JOIN dbo.mrline AS l
ON m.mrnum = l.mrnum
WHERE m.status in ('DRAFT','QAPPR') AND wonum is null AND shipto = 'FWNCS' AND s.changedate <= DATEADD(day,DATEDIFF(day,0,getdate())-90,+0) 
	AND (exists (SELECT * 
				 FROM dbo.mrline 
				 WHERE siteid = 'FWN' AND siteid = m.siteid AND mrnum != m.mrnum)
				 )
ORDER BY s.changedate desc