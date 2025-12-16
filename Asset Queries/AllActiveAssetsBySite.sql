USE max76PRD
GO


SELECT assetnum AS ASSET
	,description AS Description
	,location AS Location
	,serialnum AS 'Serial Number'
	,gmpcritical AS 'GMP Critical'
FROM dbo.asset
WHERE siteid = 'FWN' AND status in ('ACTIVE','OPERATING');
