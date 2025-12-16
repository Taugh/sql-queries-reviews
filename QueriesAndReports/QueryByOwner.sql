USE max76PRD
GO


SELECT *
FROM dbo.query
WHERE (description like 'ASPEX%' OR description like 'FWN%' OR clausename like 'ASPEX%' OR clausename like 'FWN%') 
--AND owner NOT in ('MASCAJU1','MORGAKE4','STICEBR1','US028815')