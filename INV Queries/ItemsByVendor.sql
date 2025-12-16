USE max76PRD
GO

SELECT DISTINCT i.itemnum AS 'Item Number'
	,t.description AS Description
	,curbal AS 'Current Balance'
	,minlevel AS ROP
	,orderqty AS EOQ
FROM dbo.inventory AS i
	INNER JOIN dbo.ITEM AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
	INNER JOIN dbo.invvendor AS v
ON i.itemnum = v.itemnum AND i.siteid = v.siteid --AND i.orgid = v.orgid
	INNER JOIN dbo.invbalances AS b
ON i.itemnum = b.itemnum AND i.siteid = b.siteid
WHERE t.itemsetid = 'IUS' AND i.siteid = 'FWN' AND v.vendor IN ('REYNOLDSCO','REYNOLDS - FTW','REY.CO') AND i.status != 'OBSOLETE'
