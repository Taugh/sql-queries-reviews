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
	,p.ownergroup
FROM dbo.pm AS p
	INNER JOIN dbo.asset AS a
ON p.assetnum = a.assetnum AND p.siteid = a.siteid
WHERE p.siteid = 'ASPEX' AND a.status in ('INACTIVE') AND p.status = 'ACTIVE'
ORDER BY ownergroup;