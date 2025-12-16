USE max76PRD

SELECT pmnum
	,description
	,status
	,nextdate
FROM dbo.pm
WHERE siteid = 'ASPEX' AND status = 'ACTIVE' AND frequnit NOT in ('DAYS','WEEKS') AND (DATEPART(DAY,nextdate) != 01)