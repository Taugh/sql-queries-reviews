USE max76PRD
GO


WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
		   FROM dbo.invbalances
		   WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) 
		   GROUP BY itemnum)

SELECT i.itemnum AS 'Adjustment Item'
FROM dbo.invbalances AS i
	INNER JOIN b
ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+0,0)
	AND i.physcnt > i.curbal;

--Counts items WHERE the physical COUNT is less than the current balance
WITH b AS (SELECT itemnum, MAX(physcntdate) AS maxdate
		   FROM dbo.invbalances
		   WHERE siteid = 'FWN' AND location ='FWNCS' AND physcntdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) 
		   GROUP BY itemnum)

SELECT i.itemnum AS 'Shrinkage Item'
FROM dbo.invbalances AS i
	INNER JOIN b
ON (i.itemnum = b.itemnum AND i.physcntdate = b.maxdate)
WHERE physcntdate  >= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) AND physcntdate < DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+0,0)
	AND i.physcnt < i.curbal;
