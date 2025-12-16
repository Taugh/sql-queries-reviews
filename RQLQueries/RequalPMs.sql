USE max76PRD
GO

SELECT pmnum
	,description
	,status
	,assetnum
	,jpnum
	,ownergroup
	,lastcompdate
	,nextdate
	,frequency
FROM dbo.pm
WHERE siteid = 'FWN' AND status = 'ACTIVE' AND ownergroup = 'FWNVAL' AND pmnum like 'RQ%'
