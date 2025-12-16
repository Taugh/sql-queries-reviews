USE max76PRD
GO

--Returns all transactions FROM specific person AND date
SELECT DISTINCT t.itemnum AS Item
	,i.description AS Description
	,t.binnum AS Bin
	,t.transtype AS 'Transaction Type'
	,CONVERT(varchar(10),t.transdate,23) AS 'Transaction Date'
	,t.quantity AS 'Count Difference'
	,t.curbal AS 'Current Balance'
	,t.physcnt AS 'Count'
FROM dbo.a_invtrans AS t
	INNER JOIN dbo.item AS i
ON t.itemnum = i.itemnum
	INNER JOIN dbo.inventory AS v
ON i.itemnum = v.itemnum
WHERE t.transdate >= DATEADD(DAY,-7,getdate()) AND eauditusername = 'SCHMIC2H' AND t.storeloc = 'FWNCS' AND v.status <> 'OBSOLETE'