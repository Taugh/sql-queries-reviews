USE max76PRD
GO

-- Returns spare parts for requested asset(s)
SELECT DISTINCT s.assetnum AS Asset
	,a.description AS AssetDescription
	,a.status AS AssetStatus
	,s.itemnum AS Item
	,it.description AS ItemDescription
	,i.status AS INVStatus
	,i.glaccount AS GLAccount
	,c.accountname AS AccountOwner
	,i.binnum AS Bin
	,i.manufacturer AS Manufacturer
	,i.modelnum AS 'Model Number'
	,i.orderunit AS 'Order Unit'
	,b.curbal AS CurrentBalance
	,i.issueytd AS 'YTD Usage'
	,i.issue1yrago AS 'Issued Last Year'
	,i.issue2yrago AS 'Issued 2 Yr ago'
	,i.issue3yrago AS 'Issued 3 Yr ago'
FROM dbo.sparepart AS s
	INNER JOIN dbo.inventory AS i
ON s.itemnum = i.itemnum AND s.siteid = i.siteid
	INNER JOIN dbo.item AS it
ON i.itemnum = it.itemnum AND i.itemsetid =it.itemsetid
	INNER JOIN dbo.asset AS a
ON s.assetnum = a.assetnum AND s.siteid = a.siteid
	INNER JOIN dbo.chartofaccounts AS c
ON i.glaccount = c.glaccount
	INNER JOIN dbo.invbalances AS b
ON i.itemsetid = b.itemsetid AND i.siteid = b.siteid AND i.location = b.location AND i.itemnum = b.itemnum
WHERE s.siteid = 'FWN' AND it.itemsetid = 'IUS' AND i.location = 'FWNCS' 
	AND  a.status in ('INACTIVE','DECOMMISSIONED') AND i.status != 'OBSOLETE'
	--AND it.description is NOT null AND i.status = 'OBSOLETE'
ORDER BY Asset,Item;