USE max76PRD
GO


SELECT assetnum AS Asset
	,description AS Description
	,location AS Location
	,status AS Status
FROM dbo.asset
WHERE siteid = 'FWN' AND (description like 'UV%' OR description like 'PUV%' OR description like '%FILLER%' 
	OR description like '%Bander%' OR description like '%Labeler%' OR description like '%Hoppmann%'
	OR description like '%Cartoner%' OR description like '%Wrapper%' OR description like '%CASE Packer%')