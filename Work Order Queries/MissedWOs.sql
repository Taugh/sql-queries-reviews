USE max76PRD
GO

SELECT wonum
	,description
	,assetnum
	,status
	,worktype
	,owner
	,ownergroup
	,targcompdate
	,fnlconstraint
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' AND worktype in ('CA','PM','RM') --AND targcompdate > {ts '2024-07-01 00:00:00'}
AND(targcompdate <= dateadd(month, datediff(month,0,getdate())+0, 0) AND (getdate() > dateadd(day,30, fnlconstraint) 
AND (exists(SELECT 1 FROM dbo.pm WHERE (pm.siteid = workorder.siteid AND pm.pmnum = workorder.pmnum) 
AND frequnit in ('YEARS'))))
OR
targcompdate <= dateadd(month, datediff(month,0,getdate())+0, 0) AND (getdate() > dateadd(day,3, fnlconstraint) 
AND (exists(SELECT 1 FROM dbo.pm WHERE (pm.siteid = workorder.siteid AND pm.pmnum = workorder.pmnum) 
AND frequency in ('1','2','7', '14') AND frequnit in ('DAYS','MONTHS','WEEKS'))))
OR
targcompdate <= dateadd(month, datediff(month,0,getdate())+0, 0) AND (getdate() > dateadd(day,12, fnlconstraint) 
AND (exists(SELECT 1 FROM dbo.pm WHERE (pm.siteid = workorder.siteid AND pm.pmnum = workorder.pmnum) 
AND frequency between '3' AND '5' AND frequnit in ('MONTHS'))))
OR 
targcompdate <= dateadd(month, datediff(month,0,getdate())+0, 0) AND (getdate() > dateadd(day,21, fnlconstraint) 
AND (exists(SELECT 1 FROM dbo.pm WHERE (pm.siteid = workorder.siteid AND pm.pmnum = workorder.pmnum) 
AND frequency between '6' AND '11' AND frequnit in ('MONTHS'))))))
ORDER BY ownergroup