USE max76PRD


SELECT g.persongroup AS 'Person Group'
	,g.resppartygroup AS 'Responsible Party'
	,p.firstname AS 'First Name'
	,p.lastname AS 'Last Name'
	,e.emailaddress AS 'Email'
	,g.resppartygroupseq AS 'Sequence'
	,g.useforsite AS 'Use for Site'
	,g.groupdefault AS 'Group Default'
FROM dbo.persongroupteam AS g
	INNER JOIN dbo.person AS p
ON g.resppartygroup = p.personid
	INNER JOIN dbo.email AS e
ON g.resppartygroup = e.personid
WHERE persongroup like 'FWN%' AND groupdefault = 1
ORDER BY 'Person Group'
