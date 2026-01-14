USE max76PRD

SELECT COUNT(DISTINCT jpnum) AS [Job Plans Modified or Created]
FROM dbo.a_jobplan
WHERE siteid IN ('ASPEX','FWN')
    AND eaudittimestamp >= DATEADD(YEAR,DATEDIFF(YEAR,0,CURRENT_TIMESTAMP)- 1, 0)
    AND eaudittimestamp < DATEADD(YEAR,DATEDIFF(YEAR,0,CURRENT_TIMESTAMP)+ 0, 0) 
    AND eauditusername IN ('BRANNTR1','SCHMIC2H') 
    AND (eaudittype = 'I' OR eaudittype = 'U')