USE max76PRD
GO

--Production maintenance late work orders
SELECT wonum AS 'Work Order'
	,description AS 'Description'
	,location AS 'Location'
	,assetnum AS 'Asset'
	,status AS 'Status'
	,worktype AS 'Work Type'
	,assignedownergroup AS 'Owner Group'
	,owner AS 'Assigned To'
	,targcompdate AS 'Due Date'
	,fnlconstraint AS 'Finish No Later Than'
	,actfinish AS 'Completed Date'
FROM dbo.workorder
WHERE (istask = 0 AND worktype in ('CA','PM','RM') AND woclass in ('WORKORDER','ACTIVITY')  
	AND assignedownergroup in ('FWNLC1','FWNPS') AND siteid = 'FWN' AND (actfinish >= targcompdate AND actfinish <= fnlconstraint)) 
	AND (exists (SELECT 1 
				 FROM dbo.wostatus
				 WHERE (wostatus.wonum = workorder.wonum  AND wostatus.siteid = workorder.siteid) 
					AND status in ('COMP') AND changedate > targcompdate 
					AND changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
					AND changedate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)
				)
		)
ORDER BY 'Owner Group','Work Order';