USE Max76PRD
GO

--Locate summer shutdown WOs
SELECT wonum
	,description
	,reportdate
FROM dbo.workorder
WHERE woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND siteid = 'FWN' 
	AND worktype = 'SDM' AND MONTH(reportdate) >= 1 AND  MONTH(reportdate) < 8 AND YEAR(reportdate) = 2023

--Locate winter shutdown WOs
SELECT wonum
	,description
	,reportdate
FROM dbo.workorder
WHERE (woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND siteid = 'FWN' AND worktype = 'SDM' 
	AND (MONTH(reportdate) >= 8 AND MONTH(reportdate) <=12) AND YEAR(reportdate) > 2023)
	OR (woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND siteid = 'FWN' 
	AND worktype = 'SDM' AND MONTH(reportdate) < 2 AND YEAR(reportdate) > 2024)