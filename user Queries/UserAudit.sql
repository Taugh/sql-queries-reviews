USE max76PRD
GO


SELECT m.userid
	,firstname
	,lastname
	,m.status
	,defsite
	,locationsite
	,changedate
FROM dbo.maxuser AS m
	INNER JOIN dbo.person AS p
ON m.personid = p.personid
	INNER JOIN maxuserstatus AS s
ON m.userid = s.userid
WHERE changedate > DATEADD(DAY, DATEDIFF(DAY, 0, CURRENT_TIMESTAMP) -14, 0)
	AND m.status = 'ACTIVE'
	AND defsite = 'FWN'
	--AND m.userid in ('TAYLODO4')