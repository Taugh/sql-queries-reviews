USE max76PRD

SELECT wonum
	,w.status
	,w.worktype
	,w.assignedownergroup
	,w.assetnum
	,sneconstraint AS 'Start No Earlier Than Date'
	,reportdate AS 'Report Date'
	,targcompdate AS 'Target Complete Date'
	,actstart
	,actfinish AS 'Actual Finish Date'
	,fnlconstraint AS 'Grace Period Date'
	,DATEDIFF(DAY,targcompdate,fnlconstraint) AS 'Grace Period'
	,DATEDIFF(DAY, fnlconstraint, actfinish) AS 'Days Past Grace Period'
	,p.frequency AS Frequency
	,p.frequnit AS 'Frequency Unit'
FROM dbo.workorder AS w
	LEFT JOIN dbo.pm AS p
ON w.siteid = p.siteid AND w.pmnum = p.pmnum
WHERE w.siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0 
	AND targcompdate >= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)-90,0) 
	AND targcompdate < DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0,0) 
	AND p.status = 'ACTIVE' AND w.assignedownergroup NOT IN ('AXSUPIT','FWNCAD','FWNVAL') AND w.worktype NOT IN ('CAL','CM','DOCRV','ECO','NCM','RQL','SDM') 
	AND frequnit NOT IN ('DAYS','WEEKS')
	--AND w.assignedownergroup = 'FWNAE'
ORDER BY wonum