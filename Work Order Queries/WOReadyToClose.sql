USE max76PRD
GO

SELECT wonum
	,description
	,worktype
	,status
	,owner
	,changeby
	,changedate
	,assignedownergroup
FROM dbo.workorder
WHERE (siteid in ('ASPEX','FWN') AND status in ('REVWD') AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 
	AND changedate < ((getdate()) - 45)) OR (worktype = 'AD' AND siteid = 'FWN' AND status = 'REVWD')