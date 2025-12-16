USE Max76PRD
GO


SELECT recordkey
	,description
	,class
	,logtype
	,createby
	,createdate
	,siteid
FROM dbo.worklog
WHERE siteid = 'FWN' 
	AND class = 'WORKORDER' 
	AND logtype = 'QA Approval'
	AND createdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) +0, 0)
ORDER BY createdate desc;