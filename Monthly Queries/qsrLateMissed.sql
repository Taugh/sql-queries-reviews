USE max76PRD
GO

--QSR Late WOs
SELECT wonum AS 'Work Order'
	,description AS 'Description'
	,location AS 'Location'
	,assetnum AS 'Asset'
	,status AS 'Status'
	,worktype AS 'Work Type'
	,assignedownergroup AS 'Owner Group'
	,targcompdate AS 'Due Date'
	,actfinish AS 'Completed Date'
FROM dbo.workorder
WHERE (istask = 0 AND status in ('COMP','PENRVW','MISSED','PENDQA','FLAGGED','REVWD') AND worktype in ('CA','PM','RQL') 
	AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND siteid = 'FWN' AND (actfinish >= targcompdate AND actfinish >= fnlconstraint)
	AND targcompdate > DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1, 0) 
	AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0)) 
	AND (exists 
			(SELECT 1 
			 FROM dbo.wostatus 
			 WHERE (wostatus.wonum = workorder.wonum AND wostatus.siteid = workorder.siteid) 
				AND status in ('COMP') AND changedate > targcompdate AND changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
				AND changedate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)
			)
		)
ORDER BY 'Work Order';

--QSR Missed WOs
SELECT wonum AS 'Work Order'
	,description AS 'Description'
	,location AS 'Location'
	,assetnum AS 'Asset'
	,status AS 'Status'
	,worktype AS 'Work Type'
	,assignedownergroup AS 'Owner Group'
	,targcompdate AS 'Due Date'
	,actfinish AS 'Completed Date'
FROM dbo.workorder
WHERE ((worktype in ('CA','PM','RQL')  AND status in ('MISSED')
	AND (woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate > DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1, 0) AND (fnlconstraint < GETDATE())
	AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0)))
ORDER BY 'Work Order';

