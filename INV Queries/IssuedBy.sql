USE max76PRD
GO


SELECT u.mrnum AS 'Request Number'
	,u.itemnum AS Item
	,i.description AS 'Description'
	,u.quantity AS Quantity
	,u.usetype AS'Use Type'
	,u.enterby AS 'Issued By'
	,u.issueto AS 'Issued To'
	,u.actualdate AS 'Issued Date'
FROM dbo.invuseline AS u
	INNER JOIN dbo.item AS i
ON u.itemnum = i.itemnum
WHERE u.siteid = 'FWN' AND fromstoreloc = 'FWNCS' AND enterby = 'VIERACA3' AND actualdate  >= DATEADD(DAY,-31,GETDATE())
ORDER BY [Issued Date];