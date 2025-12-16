USE max76PRD
GO

--Open POs WITH item information
SELECT p.ponum AS PO
	,p.revisionnum AS Revision
	,l.polinenum AS Line
	,p.description AS Description
	,p.vendor AS Vendor
	,p.status AS 'Status'
	,l.itemnum AS 'Item Number'
	,l.description AS 'Item Description'
	,l.orderqty AS 'Quantity Ordered'
	,COALESCE(l.receivedqty,0) AS 'Quantity Received'
	,CONVERT(varchar(10),p.orderdate,23) AS 'Order Date'
	,CONVERT(varchar(10),p.followupdate,23) AS 'Follow Up Date'
FROM dbo.poline AS l
	INNER JOIN dbo.po AS p
ON l.ponum = p.ponum
WHERE l.siteid = 'FWN' AND l.orgid = 'US' AND l.storeloc = 'FWNCS' AND p.historyflag = 0 AND p.status = 'APPR' AND l.itemnum != 'SPOTBUY'
	AND l.revisionnum = (SELECT MAX(revisionnum)
						 FROM dbo.po po2 
						 WHERE l.siteid = po2.siteid AND l.ponum = po2.ponum 
							AND po2.status NOT in (SELECT value
												   FROM dbo.synonymdomain 
												   WHERE domainid='POSTATUS' AND maxvalue in ('CAN')
												  )
						) 
	AND orderqty > COALESCE(receivedqty,0) AND p.orderdate <  DATEADD(DAY,-30,GETDATE()) 
ORDER BY PO;

--Counts the number of open POs
SELECT COUNT(DISTINCT p.ponum) AS PO
FROM dbo.poline AS l
	INNER JOIN dbo.po AS p
ON l.ponum = p.ponum
WHERE l.siteid = 'FWN' AND l.orgid = 'US' AND l.storeloc = 'FWNCS' AND p.historyflag = 0 AND p.status = 'APPR' 
	AND l.revisionnum = (SELECT MAX(revisionnum) 
						 FROM dbo.po po2 
						 WHERE l.siteid = po2.siteid AND l.ponum = po2.ponum 
							AND po2.status NOT in (SELECT value 
												   FROM dbo.synonymdomain 
												   WHERE domainid='POSTATUS' AND maxvalue in ('CAN')
												  )
						) 
	AND orderqty > COALESCE(receivedqty,0) AND p.orderdate < DATEADD(DAY, -30, GETDATE())
ORDER BY PO;