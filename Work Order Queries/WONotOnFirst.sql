USE max76PRD
GO


--Returns all scheduled work orders which do NOT fall ON the first of the month. Excludes all work orders WITH a frequency of less than one month.
SELECT wonum
	,status
	,targcompdate
FROM dbo.workorder
WHERE woclass in ('WORKORDER','ACTIVITY') AND historyflag  =  0 AND istask  =  0 AND siteid = 'FWN' AND status != 'REVWD' 
	AND pluscfrequency NOT in ('7', '14') AND pluscfrequnit NOT in ('DAYS','WEEKS') AND (DATEPART(DAY,targcompdate) != 01)