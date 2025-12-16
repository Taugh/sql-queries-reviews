USE max76PRD
GO


SELECT m.personid
	,firstname
	,lastname
	,emailaddress
FROM dbo.maxuser AS m
	INNER JOIN dbo.groupuser AS g
ON m.personid = g.userid
	INNER JOIN dbo.person AS p
ON m.personid = p.personid
	INNER JOIN dbo.email AS e
ON m.personid = e.personid
WHERE groupname in ('AXSUPER','FNSUPER') AND m.status = 'ACTIVE'
ORDER BY p.personid