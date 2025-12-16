USE max76PRD
GO

SELECT wonum
	, siteid
	,status
	,worktype
	,assignedownergroup
	,owner
	,targcompdate
	,sneconstraint
	,actstart
FROM dbo.workorder
WHERE siteid = 'ASPEX' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND actstart < sneconstraint 
	AND targcompdate > DATEADD(YEAR, DATEDIFF(YEAR,0,GETDATE()) -1, 0) 
	AND targcompdate <= DATEADD(YEAR, DATEDIFF(YEAR,0,GETDATE()) +0, 0)
	AND targcompdate != sneconstraint
	AND worktype in ('CA','PM','RM','RQL') --AND assignedownergroup = 'FWNWSM'
ORDER BY assignedownergroup