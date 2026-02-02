USE max76PRD

SELECT wonum
	,description
	,status
	,worktype
	,owner
	,assignedownergroup
	,targcompdate
FROM dbo.workorder
WHERE woclass IN ('WORKORDER','ACTIVITY') AND istask = 0 AND historyflag = 0 AND siteid = 'FWN' AND ownergroup IS NULL AND assignedownergroup IS NULL
	AND status != 'REVWD' AND worktype NOT IN ('AD','PMC')
ORDER BY owner;

