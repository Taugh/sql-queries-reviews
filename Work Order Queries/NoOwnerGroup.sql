USE max76PRD

SELECT wonum
	,description
	,location
	,status 
FROM dbo.workorder
WHERE siteid = 'FWN' AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0
	 AND (assignedownergroup is null AND ownergroup is null) AND worktype NOT in ('AD','PMC')