USE max76PRD
GO

--Counts number of scheduled work orders due for the MONTH
SELECT COUNT(wonum) AS 'Scheduled WOs'
FROM dbo.workorder
WHERE  woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND siteid = 'FWN' 
	AND worktype in ('CA','PM','RQL') AND (targcompdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) 
	AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

--Counts the number of scheduled work orders completed for the MONTH
SELECT COUNT(wonum) AS 'Completed'
FROM dbo.workorder
WHERE (worktype in ('CA','PM','RQL') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 
	AND siteid = 'FWN' AND status in ('CLOSE','COMP','CORRECTED','CORRTD','PENRVW','PENDQA','FLAGGED','REVWD')) 
	AND (targcompdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+1) 
	AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

SELECT COUNT(wonum) AS 'In Grace Period'
FROM dbo.workorder
WHERE (worktype in ('CA','PM','RQL') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND status NOT in ('COMP','CORRECTED','CORRTD','PENRVW','PENDQA','FLAGGED','REVWD')) 
	AND (targcompdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+1) 
	AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0))
			AND fnlconstraint > GETDATE();

SELECT wonum AS 'Missed Previous Month PMs'
FROM dbo.workorder
WHERE (worktype in ('CA','PM','RQL') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') 
	AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND status NOT in ('COMP','CORRECTED','CORRTD','PENRVW','PENDQA','FLAGGED','REVWD')) 
	AND (targcompdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+1) 
	AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0))
	AND fnlconstraint < GETDATE();

--Returns late PMs FROM previous MONTH
SELECT DISTINCT COUNT(wonum) AS 'Late PMs'
FROM dbo.workorder
WHERE (istask = 0 AND status in ('COMP','CORRECTED','CORRTD','PENRVW','PENDQA','FLAGGED','REVWD') AND worktype in ('CA','PM','RQL') 
	AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND siteid = 'FWN' AND (actfinish >= targcompdate 
	AND actfinish >= fnlconstraint) AND targcompdate > DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1, 0) 
	AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0))
	AND (exists (SELECT 1 
				 FROM dbo.wostatus 
				 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) AND status in ('COMP') 
					AND changedate > targcompdate AND changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
					AND changedate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)
				)
		);

--Returns missed PMs FROM previous MONTH
SELECT COUNT(wonum) AS 'Missed PMs'
FROM dbo.workorder
WHERE ((worktype in ('CA','PM','RQL') AND status NOT in ('COMP','CORRECTED','CORRTD','PENRVW','PENDQA','FLAGGED','REVWD') 
	AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) AND (fnlconstraint < GETDATE() 
	AND fnlconstraint != targcompdate)
	AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0)) 
	AND (exists (SELECT 1
				 FROM dbo.wostatus 
				 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) AND status in ('MISSED')  
					AND changedate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
					AND changedate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0))
				)
		);

--Counts CMs created FROM previous MONTH
SELECT COUNT(DISTINCT wonum) AS 'Created CMs'
FROM dbo.workorder
WHERE(worktype in ('CAL','CM','CO','PMR','WTR') AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 
	AND siteid = 'FWN' AND historyflag = 0 AND status NOT in ('CAN','CLOSE')) AND (reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

--Counts CMs complete in the previous MONTH
SELECT COUNT(DISTINCT wonum) AS 'Completed CMs'
FROM dbo.workorder
WHERE (worktype in ('CAL','CM','CO','PMR','WTR') AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND historyflag = 0
	AND siteid = 'FWN' AND ((actfinish > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+1) 
	AND actfinish < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)) OR status in ('COMP','CORRECTED','CORRTD','PENRVW','PENDQA','FLAGGED','REVWD')) 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)) AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0);

--Counts CMs still open at the END of previous MONTH
SELECT COUNT(DISTINCT wonum) AS 'Open CMs'
FROM dbo.workorder
WHERE (worktype in ('CAL','CM','CO','PMR','WTR') AND status NOT in ('CAN','CLOSE','COMP','CORRECTED','CORRTD','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
	AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

--Counts ECOs created FROM previous MONTH
SELECT COUNT(DISTINCT wonum) AS 'Created ECOs'
FROM dbo.workorder
WHERE (worktype in ('ECO') AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN') 
	AND (reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) 
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

--Counts ECOs complete in the previous MONTH
SELECT COUNT(wonum) AS 'Completed ECOs'
FROM dbo.workorder
WHERE worktype in ('ECO') AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND ((actfinish >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) AND actfinish < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)) 
	OR status in ('CAN','CLOSE','COMP','CORRECTED','CORRTD','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

--Counts ECOs still open at the END of previous MONTH
SELECT COUNT(wonum) AS 'Open ECOs'
FROM dbo.workorder
WHERE worktype in ('ECO') AND status NOT in ('CAN','CLOSE','COMP','CORRECTED','CORRTD','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
	AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0);