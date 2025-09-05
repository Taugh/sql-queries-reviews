USE max76PRD --ASPEX FWN MONTHLY QSR Query V2 Generated, Completed, MISSED
GO

DECLARE @site TABLE (siteid VARCHAR(8)) INSERT INTO @site(siteid) VALUES ('--ASPEX'),('FWN')	--Site Selection
DECLARE @date AS DATETIME = {ts '2024-01-01 00:00:00'}											--Fixed date
DECLARE @date2 AS DATETIME = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0, +0)						--Day 1, This Month
DECLARE @MonDate TABLE (PreMonDate DATETIME, CurMonDate DATETIME) 
		INSERT INTO @MonDate(PreMonDate, CurMonDate) VALUES (DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1, +0), @date2)  -- Change dates here and 

--	Work Orders Generated
SELECT
	w.wonum AS 'Work Orders Generated'
	,w.description AS 'Description'
	,w.location AS 'Location'
	,w.assetnum AS 'Asset'
	,w.status AS 'Status'
	,w.siteid AS 'Site'
	,w.worktype AS 'WorkType'
	,p.frequency AS 'PM Frequency'
	,p.frequnit AS 'PM Freq. Unit'
	,w.targcompdate AS 'Target Complete Date'
	,w.ownergroup AS 'Owner Group'
	,w.assignedownergroup AS 'Assigned Owner Group'
FROM workorder AS w
	INNER JOIN pm AS p
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE w.istask = 0 AND woclass in ('WORKORDER','ACTIVITY') AND w.siteid IN(SELECT siteid FROM @site)
	AND w.worktype IN('PM','CA','RQL')
	AND targcompdate > (SELECT PreMonDate FROM @MonDate) AND w.targcompdate <= (SELECT CurMonDate FROM @MonDate)
	--AND workorder.targstartdate > @date AND workorder.targstartdate <= @date2
ORDER BY w.wonum ASC;

--	Work Orders Completed
SELECT
	w.wonum AS 'Work Orders Completed'
	,w.description AS 'Description'
	,w.location AS 'Location'
	,w.assetnum AS 'Asset'
	,w.status AS 'Status'
	,w.siteid AS 'Site'
	,w.worktype AS 'WorkType'
	,p.frequency AS 'PM Frequency'
	,p.frequnit AS 'PM Freq. Unit'
	,w.targcompdate AS 'Target Complete Date'
	,w.actfinish AS 'Actual Finish Date'
	,w.fnlconstraint AS 'Finish No Later than Date'
	,w.ownergroup AS 'Owner Group'
	,w.assignedownergroup AS 'Assigned Owner Group'
FROM workorder AS w
	INNER JOIN pm AS p
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE
	w.istask = 0 AND woclass in ('WORKORDER','ACTIVITY') AND w.siteid IN(SELECT siteid FROM @site)
	AND w.worktype IN('PM','CA','RQL')
	AND w.actfinish > (SELECT PreMonDate FROM @MonDate)
	AND w.actfinish <= (SELECT CurMonDate FROM @MonDate)
	AND w.wonum NOT IN(SELECT s.wonum 
					   FROM wostatus AS s
					   WHERE s.wonum = w.wonum AND s.siteid = w.siteid AND s.status IN ('MISSED'))
ORDER BY w.wonum ASC;

--/*	--Work Orders MISSED
SELECT
	w.wonum AS 'Work Orders MISSED'
	,w.description AS 'Description'
	,w.location AS 'Location'
	,w.assetnum AS 'Asset'
	,w.status AS 'Status'
	,w.siteid AS 'Site'
	,w.worktype AS 'WorkType'
	,p.frequency AS 'PM Frequency'
	,p.frequnit AS 'PM Freq. Unit'
	,w.targstartdate AS 'Target Start Date'
	,w.actfinish AS 'Actual Finish Date'
	,CASE
		WHEN (w.worktype = 'RQL' OR (p.frequency IN (1,2,3) AND p.frequnit IN('WEEKS')) OR (p.frequency IN(1,2) AND p.frequnit IN('MONTHS')))	THEN w.fnlconstraint
		WHEN (p.frequency IN (3,4,5) AND p.frequnit IN ('MONTHS'))																				THEN DATEADD(DAY,9,w.fnlconstraint)
		WHEN (p.frequency IN (6,7,8,9,10,11) AND p.frequnit IN ('MONTHS'))																		THEN DATEADD(DAY,18,w.fnlconstraint)
		WHEN ((p.frequency >= 1 AND p.frequnit IN ('YEARS')) OR (p.frequency >= 12 AND p.frequnit IN ('MONTHS')))								THEN DATEADD(DAY,30,w.fnlconstraint)
	END AS 'Missed Date'
	,w.assignedownergroup AS 'Assigned Owner Group'
FROM workorder AS w
	INNER JOIN pm AS p
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE
	w.istask = 0 AND woclass in ('WORKORDER','ACTIVITY') AND w.siteid IN(SELECT siteid FROM @site)
	AND w.worktype IN ('PM','CA','RQL')
	AND w.actfinish > (SELECT PreMonDate FROM @MonDate)
	AND w.actfinish <= (SELECT CurMonDate FROM @MonDate)
	AND w.wonum IN(SELECT s.wonum 
				   FROM wostatus AS s
				   WHERE s.wonum = w.wonum AND s.siteid = w.siteid AND s.status IN('MISSED'))
ORDER BY w.wonum ASC