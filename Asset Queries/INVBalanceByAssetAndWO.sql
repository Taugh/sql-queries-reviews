USE max76PRD
GO

WITH wo AS (SELECT wonum, description, status, changedate, worktype, assetnum
			FROM dbo.workorder
			WHERE siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 
			AND (reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)+ 0, 0) OR targcompdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)+ 0, 0))
			AND assetnum in ('2151','10467','1026','10470')
			),
	
	materialuse AS (SELECT refwo, siteid, itemnum, quantity, unitcost, linecost
					FROM dbo.matusetrans 
					WHERE siteid = 'FWN'
					),

	balances AS (SELECT itemnum, curbal
				 FROM dbo.invbalances
				 WHERE siteid = 'FWN' AND itemsetid = 'IUS'
				 )

SELECT materialuse.itemnum
	,curbal
	,assetnum
FROM wo
	LEFT JOIN materialuse
ON wo.wonum = materialuse.refwo
	INNER JOIN dbo.invbalances AS i
ON materialuse.itemnum = i.itemnum
ORDER BY itemnum;