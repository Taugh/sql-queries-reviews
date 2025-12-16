USE Max76PRD
GO

--Counts the number of POs created during the last MONTH
SELECT COUNT(ponum) AS ' POs Issued'
FROM dbo.po
WHERE (historyflag = 0 AND siteid = 'FWN' AND orderdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) 
	AND orderdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

--Adds the totals of all POs for the previous MONTH
SELECT FORMAT((SUM(totalcost)),'N','en-us') AS 'Total Cost'
FROM dbo.po
WHERE (historyflag = 0 AND siteid = 'FWN' AND orderdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0) 
	AND orderdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0));

--POs open greater 30 days
SELECT COUNT(ponum) AS 'POs Greater 60'
FROM dbo.po
WHERE (historyflag = 0 AND receipts != 'COMPLETE' AND siteid = 'FWN' AND  orderdate <= DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-60,+0));

--POs open less than 60 days
SELECT COUNT(ponum) AS 'POs Less 60'
FROM dbo.po
WHERE (historyflag = 0 AND receipts != 'COMPLETE' AND siteid = 'FWN' AND  orderdate >= DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-60,+0)
	AND orderdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1,+0));

--POs WITH require by date +60 DAY
SELECT COUNT(ponum) AS 'POs +60 require date'
FROM dbo.po
WHERE (historyflag = 0 AND receipts != 'COMPLETE' AND siteid = 'FWN' AND requireddate is NOT null AND ((requireddate is NOT null 
	AND requireddate <= DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-60,+0)) 
	OR orderdate <= DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())-60,+0)));