USE max76PRD
GO

SELECT DISTINCT w.wonum
	,o.ownergroup
	,MAX(o.owndate) AS date
FROM dbo.workorder AS w
	INNER JOIN dbo.woownerhistory AS o
ON w.wonum = o.wonum AND w.siteid = o.siteid
WHERE w.owner = 'KARRUDI1' AND status = 'FLAGGED' AND worktype != 'ECO' AND o.ownergroup is NOT null
GROUP BY w.wonum, o.ownergroup
