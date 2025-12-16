USE max76PRD
GO

WITH wo AS (SELECT wonum, description, status, changedate, worktype, assetnum
			FROM dbo.workorder
			WHERE siteid = 'ASPEX' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 
			AND (reportdate >= {ts '2022-06-01 00:00:00.000'} OR targcompdate >= {ts '2022-06-01 00:00:00.000'})
			AND assetnum in ('3532','3626','3526','2143','3396','2682','3038','3416')
			),

	labor AS (SELECT refwo, laborcode, regularhrs
			  FROM dbo.labtrans
			  WHERE siteid = 'ASPEX'
			  ),

	materialuse AS (SELECT refwo, siteid, itemnum, quantity, unitcost, linecost
					FROM dbo.matusetrans 
					WHERE siteid = 'ASPEX'
					)

SELECT wonum
	,description
	,status
	,changedate
	,worktype
	,assetnum
	,laborcode
	,regularhrs
	,itemnum
	,quantity
	,unitcost
	,linecost
FROM wo
	LEFT JOIN labor
ON wo.wonum = labor.refwo
	LEFT JOIN materialuse
ON wo.wonum = materialuse.refwo
ORDER BY assetnum, changedate;