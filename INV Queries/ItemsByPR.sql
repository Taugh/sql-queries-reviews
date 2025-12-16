USE max76PRD
GO

--Returns all items that are ON active PRs
SELECT inv.itemnum
	,it.description
	,prl.prnum
	,prl.prlinenum
	,prl.orderqty
	,pr.status
	,pr.statusdate
FROM dbo.inventory AS inv
	INNER JOIN dbo.item AS it
ON inv.itemnum =it.itemnum
	INNER JOIN dbo.prline AS prl
ON inv.itemnum = prl.itemnum
	INNER JOIN dbo.pr AS pr
ON prl.prnum = pr.prnum
WHERE inv.siteid = 'FWN' AND inv.location = 'FWNCS' AND it.itemsetid = 'IUS' AND pr.siteid = 'FWN' AND inv.itemnum = '121471' --AND pr.status in ('WAPPR','APPR') 
ORDER BY inv.itemnum, pr.prnum;