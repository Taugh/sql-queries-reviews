USE Max76PRD
GO

--Returns specified person group.
SELECT g.persongroup AS 'Person Group'
	,g.resppartygroup AS 'Responsible Party'
	,p.firstname AS 'First Name'
	,p.lastname AS 'Last Name'
	,g.resppartygroupseq AS 'Sequence'
	,g.useforsite AS 'Use for Site'
	,g.groupdefault AS 'Group Default'
FROM persongroupteam AS g
	INNER JOIN person AS p
ON g.resppartygroup = p.personid
WHERE persongroup in ('FWNMICR1','FWNMICR2','FWNQACL','FWNQALO','FWNQCAST')
ORDER BY 'Person Group', 'Sequence'