USE max76PRD
GO


WITH missed_status AS (
	SELECT wonum
		,siteid
		,status
		,changedate
	FROM dbo.wostatus
	WHERE siteid = 'FWN' AND status ='MISSED' AND changedate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)
	)

SELECT w.wonum AS 'Work Order'
	,description AS 'Description'
	,location AS 'Location'
	,assetnum AS 'Asset'
	,m.status AS 'Status'
	,worktype AS 'Work Type'
	,assignedownergroup AS 'Owner Group'
	,owner AS 'Assigned To'
	,targcompdate AS 'Due Date'
	,m.changedate AS 'Date Flagged AS Missed'
FROM dbo.workorder AS w
	JOIN missed_status AS m
		ON w.wonum = m.wonum AND w.siteid = m.siteid
WHERE ((worktype in ('CA','PM','RM','RQL','CM') AND assignedownergroup in ('FWNLC1','FWNPS') AND woclass in ('WORKORDER','ACTIVITY') 
	AND istask = 0 AND w.siteid = 'FWN' AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1, 0) 
	AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0)))