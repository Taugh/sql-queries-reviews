USE max76PRD
GO

--Returns usages for last YEAR, shutdowns, AND sums all issue transactions for give time frame.
SELECT distinct inv.itemnum AS 'Item'
	,it.description AS 'Description'
	,inv.issue1yrago AS 'Last Year'
	,Usage = ABS((SELECT sum(quantity) 
				  FROM dbo.matusetrans 
				  WHERE itemnum = inv.itemnum AND issuetype = 'ISSUE' AND siteid = 'FWN' AND actualdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) -1,0) 
					AND actualdate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) +0,0)
				))
	,SummerShutdown = (SELECT sum(quantity) 
					   FROM dbo.matusetrans 
					   WHERE itemnum = inv.itemnum AND issuetype = 'ISSUE' AND siteid = 'FWN' AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) -7,0) 
						AND actualdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) -5,0)
					  )
	,WinterShutdown = (SELECT sum(quantity) 
					   FROM dbo.matusetrans 
					   WHERE itemnum = inv.itemnum AND issuetype = 'ISSUE' AND siteid = 'FWN' AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) -3,0) 
						AND actualdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE()) +0,0)
					  )
FROM dbo.inventory AS inv
	INNER JOIN dbo.matusetrans AS mat
ON inv.itemnum = mat.itemnum
	INNER JOIN dbo.item AS it
ON inv.itemnum = it.itemnum
WHERE inv.siteid = 'FWN' AND inv.location = 'FWNCS' AND inv.status = 'ACTIVE' AND it.itemsetid = 'IUS' AND mat.issuetype = 'ISSUE' 
	AND mat.actualdate >= DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) -1,0) AND mat.actualdate < DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) +0,0)
ORDER BY inv.itemnum;