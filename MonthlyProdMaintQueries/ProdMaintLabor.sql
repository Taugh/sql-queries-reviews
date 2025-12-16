USE max76PRD
GO

SELECT w.wonum AS 'Work Order'
	,w.description AS 'WO Description'
	,l.laborcode AS Labor
	,p.displayname AS Name
	,w.siteid AS 'Site'
	,assignedownergroup AS 'Group'
	,w.worktype AS 'Work Type'
	,w.status AS 'Status'
	,l.startdatetime AS 'Start Date'
	,l.finishdatetime AS 'Complete Date'
	,l.regularhrs AS 'Time'
FROM dbo.workorder AS w
	LEFT JOIN
			(dbo.labtrans AS l
				INNER JOIN dbo.person AS p
				ON l.laborcode = p.personid AND l.siteid = p.locationsite)
			ON w.wonum = l.refwo AND w.siteid = l.siteid
WHERE (w.woclass in ('WORKORDER','ACTIVITY') AND istask = 0 AND w.siteid = 'FWN' AND w.status NOT in ('WAPPR','APPR','INPRG'))
	AND w.assignedownergroup in ('FWNLC1','FWNPS','FWNLC2','FWNMOS') --AND worktype NOT in ('CA','PM','RM')	--Comment out WHEN returning all work orders
	AND l.startdatetime >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1,  0) 
	AND l.finishdatetime  < DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0,  0) 
ORDER BY assignedownergroup, l.laborcode, w.worktype, w.wonum;