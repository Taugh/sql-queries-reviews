USE max76PRD
GO


--Find WOs WITH date problems
SELECT w.wonum
	,w.description
	,w.status
	,w.jpnum
	,w. pmnum
	,w.assignedownergroup
	,p.lastcompdate
	,w.targstartdate
	,w.targcompdate
FROM dbo.pm AS p
	INNER JOIN dbo.workorder AS w
ON p.pmnum = w.pmnum AND p.siteid = w.siteid
WHERE p.frequnit NOT in ('DAYS','WEEKS') AND w.siteid = 'FWN' AND w.status in ('WAPPR','APPR','INPRG')
	AND w.status NOT in ('COMP','PENRVW','REVWD') AND w.historyflag = 0
	AND w.woclass in ('WORKORDER','ACTIVITY') AND w.istask = 0
	AND (DAY(w.targcompdate) != 01) 
ORDER BY w.targcompdate; 

--Returns all work orders that have been flagged AND NOT in a status of closed OR reviewed.
SELECT DISTINCT wo.wonum
	,wo.status
	,wo.statusdate
	,wo.changedate
	,wo.assignedownergroup
FROM dbo.workorder AS wo
	INNER JOIN dbo.wostatus AS wos
ON wo.wonum = wos.wonum AND wo.siteid = wos.siteid
WHERE (wo.istask = 0 AND wo.woclass in ('WORKORDER','ACTIVITY') AND wo.status NOT in ('CLOSE','REVWD')
	AND wo.siteid = 'FWN') AND (wos.status = 'FLAGGED' 
	AND wos.changedate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-2,+0))
ORDER BY wo.assignedownergroup;

SELECT wonum
	,changedate
	,worktype
	,status
	,actfinish
FROM dbo.workorder
WHERE istask = 0 AND woclass in ('WORKORDER','ACTIVITY') AND historyflag= 0 AND siteid = 'FWN' AND status in ('REVWD') 
	AND actfinish >= DATEADD(DAY,-1,GETDATE()) 
	AND NOT exists (
					SELECT 1 
					FROM dbo.labtrans 
					WHERE labtrans.siteid = workorder.siteid 
						AND labtrans.refwo = workorder.wonum
															   )
ORDER BY wonum desc;