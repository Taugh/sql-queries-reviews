USE max76PRD
GO

WITH active AS (SELECT itemnum
					,siteid
					,location
					,itemsetid
				FROM dbo.inventory
				WHERE siteid = 'FWN' AND itemsetid = 'IUS' AND location = 'FWNCS' AND status = 'ACTIVE'
				)

SELECT DISTINCT b.itemnum
	,binnum
	,MAX(physcntdate) AS 'Last Count Date'
FROM dbo.invbalances AS b
	INNER JOIN active
ON b.itemnum = active.itemnum AND b.siteid = active.siteid AND b.itemsetid = active.itemsetid
WHERE b.siteid = 'FWN' AND b.location = 'FWNCS'
GROUP BY b.itemnum, b.binnum, physcntdate
HAVING physcntdate is null OR MAX(physcntdate) < DATEADD(YEAR,DATEDIFF(YEAR, 0, GETDATE())+0, 0)
ORDER BY b.itemnum, 'Last Count Date'