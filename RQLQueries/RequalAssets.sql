USE max76PRD
GO

SELECT assetnum
	,description
	,status
	,location
FROM dbo.asset
WHERE siteid = 'FWN' AND assetnum like 'RQ%' AND status = 'ACTIVE'
