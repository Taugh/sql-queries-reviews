USE max76PRD
GO

--Labor for CMs
SELECT refwo AS 'Work Order'
	,w.worktype AS 'Work Type'
	,l.laborcode AS 'Labor'
	,l.regularhrs AS 'Time'
	,w.reportdate AS Date
FROM  dbo.labtrans AS l
	INNER JOIN dbo.workorder AS w
ON l.refwo = w.wonum
WHERE l.siteid = 'FWN' AND w.status NOT in ('WAPPR','APPR','INPRG') AND reportdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1, 0) 
	AND reportdate < DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0, 0) AND assignedownergroup = 'FWNLC1'
ORDER BY 'Labor';