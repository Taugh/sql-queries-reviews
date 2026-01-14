USE max76PRD

SELECT wonum,
	description,
	w.status,
	w.changedate, 
	worktype,
	owner,
	assignedownergroup,
	g.resppartygroup
FROM dbo.workorder AS w
	INNER JOIN dbo.persongroupteam AS g
ON w.assignedownergroup = g.persongroup
WHERE siteid = 'FWN'
	AND woclass IN ('WORKORDER','ACTIVITY')
	AND historyflag = 0
	AND istask = 0
	AND w.status IN ('COMP','CORRTD')
	AND w.changedate < DATEADD(DAY, -25, CURRENT_TIMESTAMP)
	AND groupdefault = 1
ORDER BY assignedownergroup, wonum;