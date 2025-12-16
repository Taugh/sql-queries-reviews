USE max76PRD
GO

--Returns requested information for the reservations of specified items
SELECT wonum
	,itemnum
	,description
	,reservedqty
	,requestedby
	,mrnum
	,ponum
FROM dbo.invreserve
WHERE siteid = 'FWN' AND wonum in ('895880','895881','895882','895887','895888','895889','895910','895911','895912','895915','898291','898293',
	'898294','898662','898669','898670','898671','898672','898682','898683','898684','898685','898898','898902','898903','898904','898906',
	'898907','898908','898919','898920','898935','898961','898962','899201','899207','899208','899209','899210','899390','899392','899393')
ORDER BY wonum;

--Returns MR information for specified items.
SELECT mrnum
	,mrlinenum
	,itemnum
	,description
	,qty
	,refwo
	,prnum
FROM dbo.mrline
WHERE siteid = 'FWN' AND mrnum in ('8420','8423','8435','8443','8455','8456','8458','8477','8479','8482','8483','8485','8486','8505','8506','8507','8536',
	'8537','8541','8558','8631','8636','8669','8718')
ORDER BY mrnum;

--Returns item issue transaction for specified items.
SELECT itemnum
	,transdate
	,quantity
FROM dbo.matusetrans
WHERE siteid = 'FWN' AND itemnum = '106535' AND issuetype = 'ISSUE' AND transdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1,+0)
	AND transdate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())+0,+0) AND itemnum <> 'SPOTBUY'
ORDER BY itemnum;

--Returns last years YTD 
SELECT itemnum
	,issue1yrago
FROM dbo.inventory
WHERE siteid = 'FWN' AND status <> 'OBSOLETE' AND itemnum <> 'SPOTBUY'
ORDER BY itemnum;

