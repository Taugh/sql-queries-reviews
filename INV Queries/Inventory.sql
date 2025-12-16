USE Max76PRD
GO

--Query to find High Volume Items
SELECT itemnum
	,status
	,reorder
	,lastissuedate
	,minlevel
	,issueytd
	,issue1yrago
	,abctype
	,ccf
	,highvolumespare
FROM dbo.inventory
WHERE (status NOT in ('INACTIVE','OBSOLETE') AND siteid = 'FWN' AND highvolumespare = 0 AND (minlevel > 1 AND issueytd >= ((minlevel+1)*3) 
	OR minlevel > 0 AND issueytd >= (minlevel*3)) OR (status NOT in ('INACTIVE','OBSOLETE') AND siteid = 'FWN' AND highvolumespare = 0 
	AND (minlevel > 1 AND issue1yrago >= ((minlevel+1)*2) OR minlevel > 1 AND issue1yrago >= (minlevel*3))))
ORDER BY itemnum;

--Returns all items WITH the high volume spare check box checked
SELECT itemnum AS Item
	,status
	,reorder
	,lastissuedate AS 'Last Issue Date'
	,minlevel AS 'Reorder Point'
	,issueytd AS 'Year to Date Issue'
	,issue1yrago AS 'Issued Last Year'
	,abctype AS 'ABC Type'
	,ccf AS 'Count Frequency'
	,highvolumespare AS 'High Volume Spare'
FROM dbo.inventory
WHERE (status NOT in ('INACTIVE','OBSOLETE') AND siteid = 'FWN' AND highvolumespare = 1)
ORDER BY itemnum;

--Returns item balances for specified items
SELECT i.itemnum AS Item
	,t.description AS 'Description'
	,i.status AS 'Status'
	,i.location AS Storeroom
	,b.curbal AS Balance
	,b.binnum AS Bin
FROM dbo.inventory AS i
	INNER JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum AND i.location = b.location
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
WHERE i.itemsetid = 'IUS' AND i.siteid = 'FWN' AND i.location = 'FWNCS' AND i.itemnum in ('100300','100748','101035')
ORDER BY Item, Bin;

--Returns balances for all items
SELECT i.itemnum AS Item
	,it.description AS 'Description'
	,i.status AS 'Status'
	,b.binnum AS Bin
	,b.curbal AS Balance
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS it
ON i.itemnum = it.itemnum
	INNER JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum AND i.location = b.location
WHERE it.itemsetid = 'IUS' AND i.siteid = 'FWN' AND i.location = 'FWNCS' AND i.status <> 'OBSOLETE'