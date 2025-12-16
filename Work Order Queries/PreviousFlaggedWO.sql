USE Max76PRD
GO

--Returns all flagged work orders FROM previous month
SELECT s.wonum
	,w.owner
	,w.assignedownergroup
	,s.changedate
FROM dbo.wostatus AS s
	INNER JOIN dbo.workorder AS w
ON s.wonum = w.wonum
WHERE s.siteid = 'FWN' AND s.status = 'FLAGGED' 
	AND s.changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)
	AND s.changedate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)
	AND (w.woclass = 'WORKORDER' OR w.woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND w.siteid = 'FWN'
ORDER BY assignedownergroup;