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
WHERE siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 
	AND historyflag = 0  
	--AND status = 'REVWD'
	--AND changedate >= DATEADD(day,datediff(day, 0, getdate())+0, 0)
	AND worktype is null
ORDER BY changedate;