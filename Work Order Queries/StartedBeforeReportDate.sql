USE max76PRD
GO

SELECT wonum
	,siteid
	,status
	,worktype
	,assignedownergroup
	,owner
	,targcompdate
	,sneconstraint
	,actstart
	,fnlconstraint
	,actfinish
	,reportdate	
FROM dbo.workorder
WHERE orgid = 'US' AND siteid = 'FWN' AND status = 'REVWD' -- find all pending review work orders
	AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND worktype in ('CA','PM','RM','RQL')
	AND (actstart < reportdate)