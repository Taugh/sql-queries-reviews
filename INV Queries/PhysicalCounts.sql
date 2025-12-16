USE max76PRD
GO

--Returns all items, by bin number, that were counted at specified time AND person
SELECT b.itemnum AS Item
	,i.description AS Description
	,b.binnum AS Bin
	,b.curbal AS 'C Balance'
	,b.physcnt AS 'PHY CNT'
	,CONVERT(varchar(10),b.physcntdate,23) AS 'PHY CNT Date'
FROM dbo.invbalances AS b
	INNER JOIN dbo.item AS i
ON b.itemnum = i.itemnum
WHERE siteid = 'ASPEX' AND physcntdate >= DATEADD(DAY,-20,GETDATE()) --AND eauditusername = 'SCHMIC2H'
ORDER BY Item;

--Count all distinct items counted during specified time frame
SELECT DISTINCT COUNT(itemnum) AS 'Items Counted'
FROM dbo.invbalances
WHERE siteid = 'ASPEX' AND physcntdate >= DATEADD(DAY,-20,GETDATE()) --AND eauditusername = 'NUNNKE2'
