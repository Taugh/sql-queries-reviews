USE max76PRD
GO

--Returns all scheduled work orders created within the last 6 days
SELECT wonum
	,description
	,location
	,assetnum
	,status
	,worktype
	,owner
	,targcompdate
	,assignedownergroup
FROM dbo.workorder
WHERE ((woclass in ('WORKORDER','ACTIVITY')) AND historyflag  =  0 AND istask  =  0 
	AND siteid  = 'FWN' AND (worktype in ('CA','PM','RM','RQL')) 
	AND reportdate  >= DATEADD( DAY,DATEDIFF( DAY,0,GETDATE())-6,0) AND status in ('WAPPR','APPR'))
ORDER BY assignedownergroup;