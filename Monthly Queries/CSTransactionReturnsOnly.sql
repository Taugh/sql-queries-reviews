USE max76PRD
GO

--Returns only
SELECT m.itemnum AS 'Item'
	,m.description AS 'Description'
	,mrnum AS 'MR'
	,ISNULL(refwo, '') AS 'Work Order'
	,enterby AS 'Entered By'
	,actualdate AS 'Return Date'
	,issuetype
FROM dbo.a_matusetrans AS m
WHERE m.siteid = 'FWN' AND CONVERT(varchar(10),eaudittimestamp,120) >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1,0) 
	AND CONVERT(varchar(10),eaudittimestamp,120) < DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0,0)
	AND issuetype = 'RETURN' --AND (w.worktype != 'AD')
ORDER BY mrnum, mrlinenum, actualdate