USE max76PRD

SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish, actstart, sneconstraint
FROM dbo.workorder
WHERE orgid = 'US' AND siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND worktype in ('CA','PM','RM','RQL')
	 AND status in ('PENRVW')
	AND EXISTS
		(SELECT 1
		 FROM dbo.worklog
		 WHERE workorder.siteid = worklog.siteid AND workorder.wonum = worklog.recordkey AND logtype = 'RISK ASSESSMENT');