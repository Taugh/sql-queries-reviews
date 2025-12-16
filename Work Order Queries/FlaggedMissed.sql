USE Max76PRD
GO


SELECT wonum
	,description
	,worktype
	,status
	,owner
	,assignedownergroup
FROM dbo.workorder
WHERE status in ('FLAGGED','MISSED') AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND CURRENT_TIMESTAMP >= dateadd(day,datediff(day,0, fnlconstraint) +14, 0)
	AND CURRENT_TIMESTAMP >= dateadd(day,datediff(day,0, statusdate) +7, 0)
	AND assignedownergroup = 'FWNAE'
