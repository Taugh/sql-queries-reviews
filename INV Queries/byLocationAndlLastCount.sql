
SELECT b.itemnum
	,b.binnum
	,b.curbal
	,physcnt
	,physcntdate
	,lastissuedate
FROM dbo.invbalances AS b
	INNER JOIN dbo.inventory AS i
ON b.siteid = i.siteid AND b.itemnum = i.itemnum
WHERE b.siteid = 'ASPEX' AND b.binnum like 'C8%' AND status != 'OBSOLETE' --AND physcntdate >= DATEADD(day,datediff(day,0,getdate())-4, 0)
ORDER BY physcntdate desc;