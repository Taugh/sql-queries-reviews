USE max76PRD --ASPEX FWN MONTHLY QSR Query V2 Generated, Completed, MISSED
GO
DECLARE @site TABLE (siteid VARCHAR(8)) INSERT INTO @site(siteid) VALUES ('--ASPEX'),('FWN')	--Site Selection
DECLARE @date AS DATETIME2 = DATETIMEFROMPARTS(2024,1,1,0,0,0,0)									--Target Year, Month, Day, etc
DECLARE @targDate TABLE (PreMonDate DATETIME2, CurMonDate DATETIME2) 
		INSERT INTO @targDate(PreMonDate, CurMonDate) VALUES (@date,DATEADD(MONTH,1,@date))		--VALUES using Target Month
DECLARE @date2 AS DATETIME2 = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()),0)						--Day 1, This Month
DECLARE @MonDate TABLE (PreMonDate DATETIME2, CurMonDate DATETIME2) 
		INSERT INTO @MonDate(PreMonDate, CurMonDate) VALUES (DATEADD(MONTH,-1,@date2),@date2)	--VALUES using Last Month
--/*	--Work Orders Generated
SELECT
	w.wonum AS 'Work Orders Generated'
	,w.description AS 'Description'
	,w.location AS 'Location'
	,w.assetnum AS 'Asset'
	,w.siteid AS 'Site'
	,w.worktype AS 'WorkType'
	,p.frequency AS 'PM Frequency'
	,p.frequnit AS 'PM Freq. Unit'
	,w.targstartdate AS 'Target Start Date'
	,w.ownergroup AS 'Owner Group'
	,w.assignedownergroup AS 'Assigned Owner Group'
FROM dbo.workorder AS w
	INNER JOIN dbo.pm AS p
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE w.istask = 0 AND w.siteid IN(
	SELECT siteid 
	FROM @site)
	AND w.worktype IN('PM','CA','RQL')
	AND targstartdate > (SELECT PreMonDate 
						FROM @MonDate) AND w.targstartdate <= (SELECT CurMonDate 
															   FROM @MonDate)
	--AND workorder.targstartdate > @date AND workorder.targstartdate <= @date2
ORDER BY w.wonum ASC
--*/
--/*	--Work Orders Completed
SELECT
	w.wonum AS 'Work Orders Completed'
	,w.description AS 'Description'
	,w.location AS 'Location'
	,w.assetnum AS 'Asset'
	,w.siteid AS 'Site'
	,w.worktype AS 'WorkType'
	,p.frequency AS 'PM Frequency'
	,p.frequnit AS 'PM Freq. Unit'
	,w.targstartdate AS 'Target Start Date'
	,w.actfinish AS 'Actual Finish Date'
	,w.fnlconstraint AS 'Finish No Later than Date'
	,w.ownergroup AS 'Owner Group'
	,w.assignedownergroup AS 'Assigned Owner Group'
FROM dbo.workorder AS w
	INNER JOIN dbo.pm AS p
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE
	w.istask = 0 AND w.siteid IN(
	SELECT siteid 
	FROM @site)
	AND w.worktype IN('PM','CA','RQL')
	AND w.actfinish > (SELECT PreMonDate 
					   FROM @MonDate)
	AND w.actfinish <= (SELECT CurMonDate 
						FROM @MonDate)
	AND w.wonum IN (SELECT wostatus.wonum 
				    FROM dbo.wostatus 
				    WHERE wostatus.wonum = w.wonum AND wostatus.siteid = w.siteid 
				    AND wostatus.status IN('MISSED'))
ORDER BY w.wonum ASC
--*/
--/*	--Work Orders MISSED
SELECT
	w.wonum AS 'Work Orders MISSED'
	,w.description AS 'Description'
	,w.location AS 'Location'
	,w.assetnum AS 'Asset'
	,w.siteid AS 'Site'
	,w.worktype AS 'WorkType'
	,p.frequency AS 'PM Frequency'
	,p.frequnit AS 'PM Freq. Unit'
	,w.targstartdate AS 'Target Start Date'
	,w.actfinish AS 'Actual Finish Date'
	,CASE
		WHEN (w.worktype = 'RQL' OR (p.frequency IN(1,2,3) AND p.frequnit IN('WEEKS')) OR (p.frequency IN(1,2) AND p.frequnit IN('MONTHS')))	THEN w.fnlconstraint
		WHEN (p.frequency IN(3,4,5) AND p.frequnit IN('MONTHS'))																				THEN DATEADD(DAY,18,w.fnlconstraint)
		WHEN (p.frequency IN(6,7,8,9,10,11) AND p.frequnit IN('MONTHS'))																		THEN DATEADD(DAY,36,w.fnlconstraint)
		WHEN ((p.frequency >= 1 AND p.frequnit IN('YEARS')) OR (p.frequency >= 12 AND p.frequnit IN('MONTHS')))								THEN DATEADD(DAY,60,w.fnlconstraint)
	END AS 'Missed Date'
	,w.ownergroup AS 'Owner Group'
	,w.assignedownergroup AS 'Assigned Owner Group'
FROM dbo.workorder AS w
	INNER JOIN dbo.pm AS p
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE
	w.istask = 0 AND w.siteid IN (SELECT siteid 
								  FROM @site)
	AND w.worktype IN('PM','CA','RQL')
	AND w.actfinish > (SELECT PreMonDate 
					   FROM @MonDate)
	AND w.actfinish <= (SELECT CurMonDate 
						FROM @MonDate)
	AND w.wonum IN (SELECT wostatus.wonum 
				    FROM dbo.wostatus 
					WHERE wostatus.wonum = w.wonum AND wostatus.siteid = w.siteid 
					AND wostatus.status IN('MISSED'))
ORDER BY w.wonum ASC
--*/