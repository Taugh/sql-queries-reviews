USE max76PRD
GO

WITH wo AS (SELECT wonum, description, status, changedate, worktype, assetnum
			FROM dbo.workorder
			WHERE siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0  AND status NOT in ('WAPPR','APPR','INPRG')
			AND (reportdate >= {ts '2018-01-01 00:00:00.000'} OR targcompdate >= {ts '2018-01-01 00:00:00.000'})
			AND assetnum in ('918','1136','1205','1208','4025','4997','9094','9116','11685','15190','15191')
			),

	labor AS (SELECT refwo, laborcode, regularhrs
			  FROM dbo.labtrans
			  WHERE siteid = 'FWN'
			  )


SELECT wonum
	,description
	,status
	,changedate
	,worktype
	,assetnum
	,laborcode
	,regularhrs	
FROM wo
	LEFT JOIN labor
ON wo.wonum = labor.refwo
ORDER BY assetnum, changedate;