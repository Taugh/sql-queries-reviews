USE max76PRD

SELECT wonum
	,description
	,status
	,worktype
	,owner
	,assignedownergroup
	,targcompdate
FROM dbo.workorder
WHERE woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND historyflag = 0 AND siteid = 'FWN' AND ownergroup is null AND assignedownergroup is null
	AND status != 'REVWD' AND worktype NOT in('AD','PMC')
ORDER BY owner;