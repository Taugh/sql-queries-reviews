USE max76PRD
GO


SELECT m.personid
	,firstname
	,lastname
	,groupname
FROM dbo.maxuser AS m
	INNER JOIN dbo.groupuser AS g
ON m.personid = g.userid
	INNER JOIN dbo.person AS p
ON groupname NOT in ('MAXDEFLTREG','MAXEVERYONE','EVERYONE','DEFLTREG') AND m.personid = p.personid
WHERE  m.status = 'ACTIVE' AND defsite = 'ASPEX'
ORDER BY p.personid