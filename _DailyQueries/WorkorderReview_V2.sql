USE max76PRD
GO

-- Work Order Review Ver. 2 
-- Checks pending review work orders to make sure they have labor and log entries. 
-- The query also checks to make sure that the work orders are not started early or are late.
-- Also verifies that the work orders have not been QA Approved

with notOntime AS (SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish, actstart, sneconstraint
				   FROM workorder
				   WHERE orgid = 'US' and siteid = 'FWN' and status in ('PENRVW')  -- find all pending review work orders
				      and woclass in ('WORKORDER','ACTIVITY') and istask = 0 and worktype in ('CA','PM','RM','RQL')
					  and (actfinish > fnlconstraint or (actstart < sneconstraint and targcompdate > {ts '2024-03-01 00:00:00.000'}))
					  and NOT EXISTS
								(SELECT *
								 FROM worklog
								 WHERE workorder.siteid = worklog.siteid and workorder.wonum = worklog.recordkey and logtype = 'QA APPROVAL')
			    ),

		noLabor AS (SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish
					FROM workorder AS w
					WHERE siteid = 'FWN' and status = 'PENRVW'and woclass in ('WORKORDER','ACTIVITY') and historyflag = 0 and istask = 0 and worktype != 'AD'
						and NOT EXISTS
								(SELECT *
								 FROM labtrans AS l
									INNER JOIN workorder AS w1
										ON l.siteid = w1.siteid and refwo = w1.wonum
								 WHERE l.siteid = w.siteid and (refwo = w.wonum or (w1.parent = w.wonum and w1.istask = 1)))
									and NOT EXISTS
											(SELECT *
											 FROM worklog
											 WHERE w.siteid = worklog.siteid and w.wonum = worklog.recordkey and logtype = 'QA APPROVAL') 
				),

	noLog AS (SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish
			  FROM workorder AS w
			  WHERE siteid = 'FWN' and status = 'PENRVW'and woclass in ('WORKORDER','ACTIVITY') and historyflag = 0 and istask = 0 and worktype != 'AD'
				and NOT EXISTS
					    (SELECT *
						 FROM worklog
						 WHERE siteid = w.siteid and recordkey = w.wonum)
			  )

SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish,
	CASE 
		WHEN (actstart < sneconstraint and targcompdate > {ts '2024-03-01 00:00:00.000'}) THEN 'Started Early' 
		WHEN actfinish > fnlconstraint THEN 'Late'
		ELSE '' 
	END AS 'Error'
FROM notOntime
UNION
SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish,
	CASE
		WHEN wonum > 0 THEN 'No Labor'
		ELSE ''
	END AS 'Error'
FROM noLabor
UNION
SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish,
	CASE
		WHEN wonum > 0 THEN 'No Log'
		ELSE ''
	END AS 'Error'
FROM noLog;


SELECT COUNT(wonum)
FROM workorder
WHERE siteid = 'FWN' and status = 'PENRVW'and woclass in ('WORKORDER','ACTIVITY') and historyflag = 0 and istask = 0 and status = 'PENRVW';