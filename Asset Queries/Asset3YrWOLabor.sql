USE max76PRD
GO

SELECT w.assetnum
	,a.description
	,SUM(CASE WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-3, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-2, 0)
		THEN 1 ELSE 0 END) AS '2022 Work Orders'
	,SUM(CASE WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-3, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-2, 0)
		THEN w.actlabhrs ELSE 0 END) AS '2022 Downtime'
	,SUM(CASE WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-2, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-1, 0)
		THEN 1 ELSE 0 END) AS '2023 Work Orders'
	,SUM(CASE WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-2, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-1, 0)
		THEN w.actlabhrs ELSE 0 END) AS '2023 Downtime'
	,SUM(CASE WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-1, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-0, 0)
		THEN 1 ELSE 0 END) AS '2024 Work Orders'
	,SUM(CASE WHEN reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-1, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP)-1, 0)
		THEN w.actlabhrs ELSE 0 END) AS '2024 Downtime'

FROM workorder AS w
	Inner JOIN asset AS a
ON w.siteid = a.siteid and w.assetnum = a.assetnum
WHERE woclass in ('WORKORDER','ACTIVITY') and istask = 0 and w.siteid = 'FWN' and worktype = 'CM' 
	and assignedownergroup IN ('FWNCSM','FWNMET','FWNWSM')
	and reportdate >= DATEADD(YEAR, DATEDIFF(YEAR,0,CURRENT_TIMESTAMP)-3, 0) and reportdate < DATEADD(YEAR, DATEDIFF(YEAR,0,CURRENT_TIMESTAMP)+0, 0)
GROUP BY w.assetnum, a.description