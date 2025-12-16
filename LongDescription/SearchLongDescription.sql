USE max76PRD

SELECT DISTINCT w.wonum
	,w.description
	,w.worktype
	,w.status
	,s.status AS swostatus
	,l.logtype
	,l.description AS logdescription
	,d.ldtext
FROM dbo.workorder AS w
	INNER JOIN dbo.wostatus AS s
ON w.siteid = w.siteid AND w.wonum = s.wonum
	INNER JOIN dbo.worklog AS l
ON w.siteid = l.siteid AND w.wonum = l.recordkey
	INNER JOIN dbo.longdescription AS d
ON w.workorderid = d.ldkey AND ldownertable = 'WORKORDER'
WHERE (w.siteid ='FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0) 
	--AND w.status in ('CLOSE') 
	--AND s.status = 'FLAGGED' 
	--AND worktype = 'PM' 
	--AND l.logtype = 'RISK ASSESSMENT' 
	--AND l.description NOT like '%late%'
	AND (d.ldtext like N'% PM %' OR d.ldtext like N'CM' OR d.ldtext like N'WO')
ORDER BY w.wonum