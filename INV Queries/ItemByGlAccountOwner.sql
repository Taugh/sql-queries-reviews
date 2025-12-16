USE max76PRD
GO


SELECT i.itemnum AS ItemNum
	,description AS Description
	,i.status AS Status
	,c.accountname AS Owner
	,i.glaccount AS GlAccount
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
	INNER JOIN dbo.chartofaccounts AS c
ON i.glaccount = c.glaccount
WHERE siteid = 'FWN' AND location = 'FWNCS' AND i.itemsetid = 'IUS' AND i.itemnum NOT like 'Z%'
	AND i.itemnum NOT in ('TESTITEM','SPOTBUY')
ORDER BY i.itemnum;