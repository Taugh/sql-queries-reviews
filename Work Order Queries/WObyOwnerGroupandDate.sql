USE max76PRD
GO


SELECT wonum AS Workorder
	,description AS Description
	,assetnum AS Asset
	,location AS Location
	,worktype AS Worktype
	,reportdate AS Reportdate
	,targcompdate AS 'Target Complete Date'
	,actfinish AS ActualFinish
	,status AS Status
	,owner AS Owner
	,actlabhrs AS ReportedHours
FROM dbo.workorder
WHERE siteid = 'FWN' AND ((targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-1,+0)
	AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)) OR (reportdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND reportdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0))) 
	AND assignedownergroup = 'FWNLC1' AND owner = 'OWENSKY3' AND istask = 0 AND woclass in ('WORKORDER','ACTIVITY')
ORDER BY 'Owner','Target Complete Date', ActualFinish;