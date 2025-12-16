USE max76PRD
GO


SELECT assignedownergroup
	,COUNT(DISTINCT wo.wonum)
FROM dbo.workorder wo
	INNER JOIN dbo.wostatus wos
ON wo.wonum = wos.wonum AND wo.siteid = wos.siteid
WHERE (wo.istask = 0 AND wo.woclass in ('WORKORDER','ACTIVITY') AND wo.siteid = 'FWN') 
	AND (wos.status = 'FLAGGED' AND wos.changedate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND targcompdate > DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0))
GROUP BY assignedownergroup