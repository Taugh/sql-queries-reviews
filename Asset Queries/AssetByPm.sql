USE max76PRD
GO


SELECT DISTINCT a.assetnum AS Asset
	,a.description AS Description
	,a.status AS Status
	,a.assettype AS Type
	,a.location AS Location
FROM dbo.asset AS a
	INNER JOIN dbo.pm AS p
ON a.assetnum = p.assetnum AND a.siteid = p.siteid
WHERE p.siteid = 'FWN' AND assettype = 'REQUAL' -- AND p.status = 'ACTIVE'
ORDER BY Asset;