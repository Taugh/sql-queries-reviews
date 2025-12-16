USE max76PRD
GO

--Returns  the count of open CMs AND number of days open
SELECT assignedownergroup
	,COUNT(DISTINCT wonum) AS 'Total Work Orders'
	,AVG(DATEDIFF(DAY, reportdate, GETDATE())) AS 'Days Open'
FROM dbo.workorder 
WHERE siteid = 'FWN' AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 AND historyflag = 0
	AND status in ('WAPPR','APPR','INPRG','COMP') AND worktype in ('CM')
	AND reportdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) -0,0)
GROUP BY assignedownergroup;

--Returns  the count of open ECOs AND number of days open
SELECT assignedownergroup
	,COUNT(DISTINCT wonum) AS 'Total Work Orders'
	,AVG(DATEDIFF(DAY, reportdate, GETDATE())) AS 'Days Open'
FROM dbo.workorder 
WHERE siteid = 'FWN' AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 AND historyflag = 0
	AND status in ('WAPPR','APPR','INPRG','COMP') AND worktype in ('ECO')
	AND reportdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) -1,0)
GROUP BY assignedownergroup;

-- Returns the number of work orders for the specified work type AND time frame.
SELECT COUNT(wonum) AS 'Total Work Orders'
FROM dbo.workorder 
WHERE siteid = 'FWN' AND worktype in ('CM')
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) 
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0);

--Counts the number of work orders completed in less than 15 days FROM report date.
SELECT COUNT(wonum) AS 'less than 15 days'
FROM dbo.workorder
WHERE (worktype in ('ECO') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-48,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0)AND siteid = 'FWN') 
	AND (exists (SELECT 1 
				 FROM dbo.wostatus 
				 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) AND status in ('COMP') 
					AND changedate > workorder.reportdate AND changedate < DATEADD(DAY,15,workorder.reportdate)
				)
		);

--Counts the number of work orders completed in less than 30 days FROM report date.
SELECT COUNT(wonum) AS '30 days OR less'
FROM dbo.workorder
WHERE (worktype in ('ECO') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-48,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0)
	AND siteid = 'FWN') AND (exists (SELECT 1 FROM dbo.wostatus WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) 
	AND status in ('COMP') AND changedate >workorder.reportdate AND changedate >= DATEADD(DAY,15,workorder.reportdate) 
	AND changedate < DATEADD(DAY,30,workorder.reportdate)));

--Counts the number of work orders completed in less than 45 days FROM report date.
SELECT COUNT(wonum) AS '45 days OR less'
FROM dbo.workorder
WHERE (worktype in ('ECO') 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-48,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0)
	AND siteid = 'FWN') AND (exists (SELECT 1 FROM dbo.wostatus WHERE (wostatus.wonum = workorder.wonum 	 
	AND wostatus.siteid = workorder.siteid) AND status in ('COMP') AND changedate >workorder.reportdate 
	AND changedate >= DATEADD(DAY,30,workorder.reportdate)AND changedate < DATEADD(DAY,45,workorder.reportdate)));

--Counts the number of work orders completed in less than 60 days FROM report date.
SELECT COUNT(wonum) AS '60 days OR less'
FROM dbo.workorder
WHERE (worktype in ('ECO') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-48,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0) AND siteid = 'FWN') 
	AND (exists (SELECT 1 
				 FROM dbo.wostatus 
				 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) 
					AND status in ('COMP') AND changedate >workorder.reportdate AND changedate >= DATEADD(DAY,45,workorder.reportdate) 
					AND changedate < DATEADD(DAY,60,workorder.reportdate)
				 )
		);

--Counts the number of work orders completed in less than 60 days FROM report date.
SELECT COUNT(wonum) AS '60 days OR more'
FROM dbo.workorder
WHERE (worktype in ('ECO') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-48,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0)
	AND siteid = 'FWN') 
	AND (exists (SELECT 1 
				 FROM dbo.wostatus 
				 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) AND status in ('COMP') 
					AND changedate >workorder.reportdate AND changedate >= DATEADD(DAY,60,workorder.reportdate) 
					AND changedate < DATEADD(DAY,365,workorder.reportdate)
				 )
		);

--Counts the number of work orders completed in less than 90 days FROM report date.
SELECT COUNT(wonum) AS '90 days OR more'
FROM dbo.workorder
WHERE (worktype in ('ECO') AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 
	AND reportdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-48,+0)
	AND reportdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-36,+0)
	AND siteid = 'FWN') 
	AND (exists (SELECT 1
				 FROM dbo.wostatus 
				 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) AND status in ('COMP') 
					AND changedate >workorder.reportdate AND changedate > DATEADD(DAY,365,workorder.reportdate) 
					AND changedate < DATEADD(DAY,730,workorder.reportdate)
				 )
		);