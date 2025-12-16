USE max76PRD
GO

--Returns all approved PRs WITH  line items NOT ON a PO
SELECT p.prnum AS PR
	,l.prlinenum AS Line
	,p.description AS Description
	,p.siteid AS Site
	,p.vendor AS Vendor
	,p.status AS Status
	,l.itemnum AS 'Item Number'
	,l.description AS 'Item Description'
	,l.orderqty AS 'Quantity Ordered'
	,l.ponum AS PO
	,CONVERT(varchar(10),p.issuedate,23) AS 'Order Date'
FROM dbo.prline AS l
	INNER JOIN dbo.pr AS p
ON l.prnum = p.prnum
WHERE p.siteid = 'ASPEX' AND p.orgid = 'US' AND l.storeloc = 'ASPCS' AND p.historyflag = 0 AND p.status = 'APPR' 
AND p.issuedate < GETDATE() AND l.ponum is null
ORDER BY PR, Line;

--Counts all open PRs
SELECT COUNT(DISTINCT p.prnum) AS PR			
FROM dbo.prline AS l
	INNER JOIN dbo.pr AS p
ON l.prnum = p.prnum
WHERE p.siteid = 'ASPEX' AND p.orgid = 'US' AND l.storeloc = 'ASPCS' AND p.historyflag = 0 AND p.status = 'APPR'  
	AND p.issuedate < GETDATE() AND l.ponum is null
ORDER BY PR;

--Returns all items ON PRs that are NOT ON POs for specified time frame
SELECT prnum
	,itemnum
	,description
	,orderqty
	,orderunit
	,requestedby
	,refwo
	,mrnum
	,mrlinenum
	,enterdate
FROM dbo.prline 
WHERE storeloc = 'FWNCS' AND enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-3,+0) 
	AND ponum is null
ORDER BY prnum;