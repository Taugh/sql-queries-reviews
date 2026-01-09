USE max76PRD
GO


SELECT DISTINCT pmnum
	,description
	,status
	,eaudittimestamp
	,eaudittype
	,eauditusername
FROM dbo.a_pm
WHERE siteid = 'FWN' 
	AND eaudittimestamp >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())- 1, 0)
	AND eaudittimestamp < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())+ 0, 0) 
	AND eauditusername = 'BRANNTR1' 
	AND (eaudittype = 'I' OR status = 'INACTIVE')