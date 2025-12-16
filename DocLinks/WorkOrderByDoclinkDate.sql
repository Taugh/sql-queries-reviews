USE max76PRD

SELECT w.wonum
	,workorderid
	,ownerid
	,document
	,createby
	,createdate
	,d.siteid
FROM dbo.doclinks AS d
	INNER JOIN dbo.workorder AS w
ON d.ownerid =w.workorderid
WHERE d.siteid = 'FWN' 
AND ownertable = 'WORKORDER' 
AND createdate >= {ts '2025-05-12 00:00:00'} 
--AND w.status != 'CLOSE';