USE max76PRD
GO

--Shrinkage only last 7 days
SELECT t.itemnum
	,transdate --Removed max(transdate) GROUP BY
	,enterby
	,transtype
	,quantity
	,curbal
	,physcnt
	,t.binnum
	,glaccount
FROM dbo.invtrans AS t
	INNER JOIN dbo.inventory AS i
ON t.itemnum = i.itemnum AND i.siteid = t.siteid
WHERE t.siteid = 'FWN' AND transtype = 'RECBALADJ' AND transdate >= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)-7, 0) 
	AND transdate < DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP) +0 , 0) AND quantity < 0
--GROUP BY itemnum, transtype, enterby, quantity, curbal, physcnt, binnum