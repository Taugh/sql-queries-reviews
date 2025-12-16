USE max76PRD
GO

--Returns all transaction for user AND date specified
SELECT m.itemnum AS Item
	,i.description AS Description
	,m.issuetype AS 'Transaction Type'
	,CONVERT(varchar(10),m.transdate,23) AS 'Transaction Date'
	,m.quantity AS Quantity
	,m.frombin AS 'FROM Bin'
	,m.tobin AS 'To Bin'
FROM dbo.a_matrectrans AS m
	INNER JOIN dbo.item AS i
ON m.itemnum = i.itemnum
WHERE m.transdate >= DATEADD(DAY,-7,GETDATE()) AND eauditusername = 'SCHMIC2H'
	AND m.siteid = 'FWN'