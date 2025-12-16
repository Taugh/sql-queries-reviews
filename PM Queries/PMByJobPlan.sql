USE max76PRD
GO


SELECT pmnum AS 'PM Number'
	,p.description AS 'PM Description'
	,p.status AS 'PM Status'
	,p.assetnum AS Asset
	,a.description AS 'Asset Description'
	,a.location AS Location
	,a.status AS 'Asset Status'
	,p.siteid AS Site
	,jpnum AS 'Job Plan'
	,nextdate AS 'Due Date'
	,frequency AS Frequency
	,frequnit AS 'Frequency Unit'
FROM dbo.pm AS p
	INNER JOIN dbo.asset AS a
ON p.assetnum = a.assetnum
WHERE p.siteid = 'FWN' AND jpnum in ('JP0589I','JP1719','JP2135','JP2136','JP2137','JP2138','JP2139','JP2140','JP2141','JP2142','JP2143','JP2144','JP2161') 
	--AND p.status = 'ACTIVE'