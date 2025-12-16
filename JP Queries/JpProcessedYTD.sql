USE max76PRD
GO


SELECT DISTINCT jpnum
    ,description
FROM dbo.a_jobplan
WHERE siteid = 'FWN' AND eaudittimestamp >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) + 0, 0) AND eauditusername = 'BRANNTR1'
