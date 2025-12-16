USE max76PRD
GO


SELECT DISTINCT i.itemnum
	,i.minlevel AS 'current ROP'
	,a.minlevel AS 'previous ROP'
--	,lastcost
--	,MAX(eaudittimestamp) AS lastChange
FROM dbo.a_inventory AS a
	INNER JOIN dbo.inventory AS i
ON a.siteid = i.siteid AND a.itemnum = i.itemnum
	INNER JOIN dbo.invcost AS c
ON i.siteid = c.siteid AND i.itemnum = c.itemnum
WHERE i.siteid = 'ASPEX' AND i.location = 'ASPCS' AND eaudittimestamp >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE())+0,+0) AND i.minlevel != a.minlevel
--GROUP BY i.itemnum, i.minlevel, a.minlevel, lastcost, i.siteid, i.location, eaudittimestamp
--HAVING eaudittimestamp = MAX(eaudittimestamp)
ORDER BY itemnum

