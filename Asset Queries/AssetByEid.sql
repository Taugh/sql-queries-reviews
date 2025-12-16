USE max76PRD
GO


SELECT assetnum AS 'EID #'
	,description AS 'Description'
	,status AS 'Status'
	,asset.location AS 'Location'
	,siteid
	,asset.gmpcritical AS 'GMP Critical'
	,assettype AS 'Asset Type'
	,manufacturer AS 'Manufacturer'
	,serialnum AS 'Serual #'
FROM dbo.asset
WHERE siteid = 'ASPEX' AND location != 'DISPOSED' /*AND assettype NOT in ('METROLOGY','FACILITIES','STERILIZER')*/
	AND status NOT in ('INACTIVE','DECOMMISSIONED') 
	AND (assetnum NOT like 'RQ%' AND assetnum in ('2420','2930','3137','3158','3185','3186','3187','3196','3266','3269','3271','3272','3273','3274','3288','3290','3293','3294','3336','3337','3338','3339','3340','3386','3396','3419','3613','3627','5548','5559','5666
'))