USE max76PRD
GO

--For Inventory Usage per maintenance team. Change assigned owner group in the WHERE clause.
SELECT mr.mrnum AS 'Requisition'
	,mr.description AS 'Requisition Description'
	,mr.requestedby AS 'Requsted By'
	,mr.requestedfor AS 'Requested For'
	,CONVERT(varchar(10),mr.enterdate,120) AS 'Requested Date'
	,mr.status AS 'Status'
	,mr.siteid AS 'Site'
	,mr.wonum AS 'Work Order'
	,mrl.mrlinenum AS 'Item Line #'
	,mrl.itemnum AS 'Item #'
	,mrl.description AS 'Item Description'
	,mrl.qty AS 'Quantity'
	,mrl.unitcost AS 'Unit Cost'
	,mrl.linecost AS 'Line Cost'
	,wo.assignedownergroup AS 'Owner Group'
FROM dbo.mr 
	INNER JOIN dbo.mrline AS mrl
		ON mr.mrnum = mrl.mrnum
	INNER JOIN dbo.workorder AS wo
		ON mrl.refwo = wo.wonum
WHERE mr.siteid = 'FWN' AND mr.status NOT in ('CAN','DRAFT') AND (assignedownergroup in ('FWNLC1','FWNPS') OR ownergroup in ('FWNLC1','FWNPS'))
	AND mr.enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND mr.enterdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)
ORDER BY wo.assignedownergroup, mr.requestedby asc, mr.enterdate;


