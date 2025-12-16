USE max76PRD
GO

--Issue items only previous month
SELECT ISNULL(m.mrnum, 'No MR') AS 'MR'
	,ISNULL(m.mrlinenum, '') AS 'MR Line'
	,w.assetnum AS Asset
	,a.description AS 'Asset Descriotion' 
	,m.itemnum AS 'Item'
	,m.description AS 'Description'
	,r.qty AS 'MR Requested QTY'
	,p.itemqty AS 'WO Planned QTY'
	,quantity AS 'Issued Quantity'
	,m.binnum AS 'FROM Bin'
	,ISNULL(m.refwo, '') AS 'Work Order'
	,w.worktype AS 'Work Type'
	,m.issueto AS 'ISSUED To'
	,enterby AS 'Issued By'
	,actualdate AS 'Issue Date'
	,ISNULL(memo,'') AS Memo
	,issuetype
FROM dbo.a_matusetrans AS m
	LEFT JOIN dbo.workorder AS w
		ON m.refwo = w.wonum AND m.siteid = w.siteid
	LEFT JOIN dbo.mrline AS r
		ON m.mrnum = r.mrnum AND m.mrlinenum = r.mrlinenum AND m.siteid = r.siteid
	LEFT JOIN dbo.wpmaterial AS p
		ON m.refwo = p.wonum AND m.siteid = p.siteid AND m.itemnum = p.itemnum
	LEFT JOIN dbo.asset AS a
		ON w.assetnum = a.assetnum AND w.siteid = a.siteid
WHERE m.siteid = 'FWN' AND CONVERT(varchar(10),eaudittimestamp,120) >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())-1,0) 
	AND CONVERT(varchar(10),eaudittimestamp,120) < DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+0,0)
	AND issuetype = 'ISSUE' --AND (w.worktype != 'AD')
ORDER BY m.mrnum, m.mrlinenum, actualdate

  
