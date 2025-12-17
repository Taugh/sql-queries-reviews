Use max76PRD
GO

--Items WITH Reorder off
SELECT distinct inv.itemnum AS 'Item #'
	,it.description AS 'Item Description'
	,inv.status AS 'Item Status'
	,inv.gmpcritical AS 'GMP Critical'
	,inv.criticalspare AS 'Critical Spare'
	,ISNULL(CONVERT(varchar(10),inv.lastissuedate,120),'') AS 'Last Issued'
	,ISNULL(b.curbal, 0) AS 'Current Balance'
	,ISNULL(r.reservedqty, 0) AS 'Reserved Quantity'
	,COALESCE ((b.curbal - r.reservedqty), b.curbal, 0) AS 'Available Quantity' 
	,inv.issueytd AS 'YTD Issue'
	,inv.issue1yrago AS 'Issued Last Year'
	,sp.assetnum AS 'WHERE Used'
	,ISNULL(a.description, '') AS 'Description'
	,inv.glaccount AS 'GL Account'
	,c.accountname AS 'GL Account Owner'
FROM dbo.inventory AS inv
	INNER JOIN dbo.item AS it
ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
	LEFT JOIN dbo.invreserve AS r
ON inv.itemnum = r.itemnum AND inv.location = r.location
	LEFT JOIN dbo.invbalances AS b
ON inv.itemnum = b.itemnum AND inv.location = b.location
	LEFT JOIN dbo.sparepart AS sp
ON inv.itemnum = sp.itemnum
	INNER JOIN dbo.asset AS a
ON sp.assetnum = a.assetnum
	INNER JOIN dbo.chartofaccounts AS c
ON inv.glaccount = c.glaccount
WHERE it.itemsetid = 'IUS'  AND inv.siteid = 'FWN' AND inv.location = 'FWNCS' AND inv.status NOT in ('INACTIVE','PENDOBS','OBSOLETE') 
	AND inv.reorder = 0 AND a.siteid = 'FWN'
ORDER BY 'GL Account Owner', 'Item #';

--Counts all items WITH the reorder checkbox unchecked
Use Max76PRD
GO

SELECT COUNT(inv.itemnum)
FROM dbo.inventory AS inv
WHERE inv.siteid = 'FWN' AND inv.location = 'FWNCS'
			AND inv.status NOT in ('INACTIVE','PENDOBS','OBSOLETE') AND inv.reorder = 0;