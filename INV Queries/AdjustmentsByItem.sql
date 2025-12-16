USE max76PRD
GO


--Counts items WHERE the physical COUNT is greater than the current balance 
WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
				    FROM dbo.invbalances
				    WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) 
				    GROUP BY itemnum)

SELECT i.itemnum AS 'Adjustment'
FROM dbo.invbalances AS i
			JOIN b
ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)
			AND i.physcnt > i.curbal;

--Counts items WHERE the physical COUNT is less than the current balance
WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
				   FROM dbo.invbalances
				   WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) 
				   GROUP BY itemnum)

SELECT i.itemnum AS 'Shrinkage'
FROM dbo.invbalances AS i
			INNER JOIN b
ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)
			AND i.physcnt < i.curbal;