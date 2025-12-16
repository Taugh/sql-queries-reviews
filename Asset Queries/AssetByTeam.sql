USE max76PRD
GO


SELECT DISTINCT a.assetnum AS Asset
	,a.description AS Description
	,a.location AS Location
	,a.status AS Status
	,p.ownergroup AS 'Owner Group'
	,p.assignedownergroup AS 'Assigned Group'
FROM dbo.asset AS a
	INNER JOIN dbo.pm AS p
ON a.assetnum = p.assetnum AND a.siteid = p.siteid
WHERE p.siteid = 'FWN' AND p.status = 'ACTIVE' AND (p.ownergroup in ('FWNCSM','FWNMET','FWNWSM') OR p.assignedownergroup in ('FWNCSM','FWNMET','FWNWSM'))
ORDER BY 'ASSET';