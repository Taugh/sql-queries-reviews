USE max76PRD
GO

WITH wo AS (SELECT wonum, description, status, changedate, worktype, assetnum
			FROM dbo.workorder
			WHERE siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 
			AND (reportdate >= {ts '2018-01-01 00:00:00.000'} OR targcompdate >= {ts '2018-01-01 00:00:00.000'})
			AND assetnum in ('918','1136','1205','1208','4025','4997','9094','9116','11685','15190','15191')
			),
	
	materialuse AS (SELECT refwo, siteid, itemnum, quantity, unitcost, linecost
					FROM dbo.matusetrans 
					WHERE siteid = 'FWN'
					)

SELECT wonum
	,description
	,status
	,changedate
	,worktype
	,assetnum
	,itemnum
	,quantity
	,unitcost
	,linecost
FROM wo
	LEFT JOIN materialuse
ON wo.wonum = materialuse.refwo
ORDER BY assetnum, changedate;