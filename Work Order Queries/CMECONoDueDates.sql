USE max76PRD
GO

--Returns all active CM without a target due date which have been created within the last DAY.
SELECT wonum
	,description
	,worktype
	,status
	,owner
FROM dbo.workorder
WHERE (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND status in ('WAPPR','APPR','INPRG') AND worktype = 'CM' AND reportdate >= DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-1,+0) 
	AND targcompdate is null;

--Returns all active ECO without a target due date which have been created within the last DAY.
SELECT wonum
	,description
	,worktype
	,status
	,owner
FROM dbo.workorder
WHERE (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND status in ('WAPPR','APPR','INPRG') AND worktype = 'ECO' AND reportdate > DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-1,+0) 
	AND targcompdate is null;