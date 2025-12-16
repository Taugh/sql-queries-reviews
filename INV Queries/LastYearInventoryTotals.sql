USE max76PRD
GO


SELECT COUNT(polinenum) 
FROM dbo.matrectrans 
WHERE siteid=  'FWN' AND actualdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) -1,0)
	AND actualdate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) +0,0)

SELECT SUM(l.orderqty) AS 'Total Items Ordered'
FROM dbo.po AS p
	INNER JOIN dbo.poline AS l
ON p.ponum = l.ponum
WHERE ( receipts in ('COMPLETE','PARTIAL')  AND status != 'CAN' AND p.siteid = 'FWN' AND  orderdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1,+0)
	AND orderdate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())+0,+0));

SELECT COUNT(i.itemnum) AS 'New Items'
FROM dbo.inventory AS i
	INNER JOIN dbo.invstatus AS s
ON i.itemnum = s.itemnum
WHERE i.itemsetid = 'IUS' AND i.status in ('ACTIVE','PLANNING') AND changedate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1,0)
	AND changedate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())+0,0)
	AND i.location = 'FWNCS';

--Counts the number of POs created during the last YEAR
SELECT COUNT(ponum) AS 'Total POs'
FROM dbo.po
WHERE (siteid = 'FWN' AND orderdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1,+0) 
	AND orderdate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())+0,+0));