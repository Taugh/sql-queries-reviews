USE max76PRD


SELECT servername
	,taskname
	,lastrun
	,seed
	,servertimestamp
	,lastend
FROM dbo.taskscheduler
WHERE lastrun >= DATEADD(day,DATEDIFF(day,0,GETDATE())+0,0)
