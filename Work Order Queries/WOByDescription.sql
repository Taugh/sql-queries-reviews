USE max76PRD


SELECT w.wonum
	,w.description
	,w.status
	,w.jpnum
	,w. pmnum
	,w.assignedownergroup
	,p.lastcompdate
	,w.targstartdate
	,w.targcompdate
FROM dbo.workorder AS w
	INNER JOIN dbo.pm AS p
ON w.pmnum = p.pmnum AND w.siteid = p.siteid
WHERE w.siteid = 'FWN' AND w.description like '%compressed air%' AND w.reportdate >= DATEADD(month, datediff(month,0,CURRENT_TIMESTAMP)-9, 0)
	AND w.reportdate < DATEADD(month, datediff(month,0,CURRENT_TIMESTAMP)-4, 0)
ORDER BY w.statusdate desc;