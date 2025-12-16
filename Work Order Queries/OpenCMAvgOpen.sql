USE Max76PRD
GO

--Returns all non-scheduled WOs AND calculates the average days open for each owner group
SELECT wo.assignedownergroup
	,COUNT(DISTINCT wo.wonum) AS '#WOs'
	,AVG(DATEDIFF(DAY,reportdate,GETDATE())) AS 'AVG Days Open'
FROM dbo.workorder AS wo
WHERE (wo.istask = 0 AND wo.woclass in ('WORKORDER','ACTIVITY') AND wo.siteid = 'FWN') AND wo.status in ('WAPPR','APPR','INPRG') 
	AND worktype NOT in ('AD','CA','DOCRV','ECO','PM','PMC','RM','RQL','SDM')
GROUP BY assignedownergroup 
ORDER BY assignedownergroup;