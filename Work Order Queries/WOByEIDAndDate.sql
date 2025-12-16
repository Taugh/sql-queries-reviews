USE max76PRD

SELECT wonum
	,description
	,status
	,reportdate
	,worktype
	,w.assetnum
	,w.targcompdate
	,actstart
	,actfinish
	,assignedownergroup
	,regularhrs
	,laborcode
FROM dbo.workorder AS w
	INNER JOIN dbo.labtrans AS l
ON w.wonum = l.refwo AND w.siteid = l.siteid
WHERE w.siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND worktype NOT in ('AD','CA','ECO','RM','PM','RQL','SDM') 
	AND w.assetnum in ('3360','4023','6370','10109','10340','10992','13385','15314','15451','17281')
	AND reportdate >= {ts '2022-01-01 00:00:00'} --AND reportdate < {ts '2025-01-01 00:00:00'}
ORDER BY w.assetnum, reportdate, w.wonum;