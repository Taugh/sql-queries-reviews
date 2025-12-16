USE max76PRD
GO

SELECT DISTINCT(i.itemnum) AS Item
	,description AS Description
	,b.binnum AS Bin
	,abctype AS 'ABC Type'
	,ccf AS 'Count Frequency'
	,COUNT(physcnt) AS 'Times Counted YTD'
FROM dbo.a_invbalances AS b
	INNER JOIN dbo.inventory AS i
ON b.siteid = i.siteid AND b.itemnum = i.itemnum AND b.itemsetid = i.itemsetid
	INNER JOIN dbo.item AS t
ON b.itemnum = t.itemnum AND b.itemsetid = t.itemsetid
WHERE i.siteid = 'FWN' AND i.itemsetid = 'IUS' AND t.status = 'ACTIVE' AND i.itemnum != 'SPOTBUY'
GROUP BY i.itemnum, description, b.binnum, abctype, ccf, physcntdate
HAVING physcntdate > DATEADD(YEAR,DATEDIFF(YEAR, 0, GETDATE())+0, 0)
ORDER BY 'Times Counted YTD'