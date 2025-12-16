USE max76PRD

SELECT wonum
	,description
	,status
	,worktype
	,pmnum
	,w.siteid
	,laborcode
FROM dbo.workorder AS w
	INNER JOIN dbo.labtrans AS l
ON w.siteid = l.siteid AND w.wonum = l.refwo
WHERE w.siteid ='ASPEX' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND laborcode = 'WALDRKR1'
