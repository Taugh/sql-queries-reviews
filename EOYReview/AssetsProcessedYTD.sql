USE max76PRD

SELECT COUNT(DISTINCT assetnum) AS [Assets Modified or Created]
FROM dbo.a_asset
WHERE siteid IN ('ASPEX','FWN')
	AND eaudittimestamp >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())- 1, 0)
	AND eaudittimestamp < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())+ 0, 0) 
	AND eauditusername IN ('BRANNTR1','SCHMIC2H')
	AND (eaudittype = 'I' OR eaudittype = 'U')