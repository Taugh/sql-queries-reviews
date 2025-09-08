USE max76PRD
GO


SELECT m.personid
	,firstname
	,lastname
	,emailaddress
From maxuser AS m
	INNER JOIN groupuser AS g
ON m.personid = g.userid
	INNER JOIN person AS p
ON m.personid = p.personid
	INNER JOIN email AS e
ON m.personid = e.personid
Where groupname in ('AXSUPER','FNSUPER') and m.status = 'ACTIVE'
ORDER BY p.personid