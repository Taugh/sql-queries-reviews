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
WHERE siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 --AND historyflag = 0  
	AND status = 'REVWD'
	AND changedate >= DATEADD(DAY,datediff(DAY, 0, GETDATE())+0, 0)
	--AND pmnum in ('E3485-31')
ORDER BY changedate