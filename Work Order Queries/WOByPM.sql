USE max76PRD
GO


SELECT wonum AS Workorder
	,description AS Description
	,assetnum AS Asset
	,location AS Location
	,worktype AS Worktype
	,pmnum
	,reportdate AS Reportdate
	,targcompdate AS 'Target Complete Date'
	,actfinish AS ActualFinish
	,status AS Status
	,owner AS Owner
	,actlabhrs AS ReportedHours
FROM dbo.workorder
WHERE  siteid = 'ASPEX' AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 
	AND pmnum in ('')