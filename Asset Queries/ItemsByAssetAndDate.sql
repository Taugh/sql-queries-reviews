USE max76PRD
GO

SELECT m.itemnum
	,m.description
	,m.assetnum
	,storeloc
	,transdate
	,quantity
	,lastcost
	,abs(quantity * lastcost) AS Total
	,wonum
	, w.worktype
FROM dbo.matusetrans AS m
	INNER JOIN dbo.invvendor AS v
ON m.itemnum = v.itemnum AND m.siteid = v.siteid
	INNER JOIN dbo.workorder AS w
ON m.siteid = w.siteid AND m.refwo = wonum
WHERE m.siteid = 'FWN' AND w.worktype = 'CM' AND transdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-5, 0) 
	AND transdate < DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1, 0)
	AND v.isdefault ='1'
ORDER BY itemnum;
