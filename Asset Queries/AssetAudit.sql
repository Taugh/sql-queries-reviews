USE max76PRD
GO

SELECT assetnum AS Asset
	,description AS Description
	,status AS Status
	,assettype AS Type
	,location AS Location
FROM dbo.a_asset
WHERE siteid = 'FWN' AND assetnum = ' 7527'
ORDER BY eaudittimestamp desc;
