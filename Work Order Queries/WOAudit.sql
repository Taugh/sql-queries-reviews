USE max76PRD
GO


SELECT wonum
	,description
	,status
	,pmnum
	,changeby
	,changedate
	,ownergroup
	,assignedownergroup
	,eaudittimestamp
	,eaudittype
	,eauditusername
FROM dbo.a_workorder
WHERE siteid = 'FWN' 
	--AND historyflag = 0 
	AND istask = 0 AND woclass in ('WORKORDER','ACTIVITY')
	--AND owner in ('856902','858046')
	--AND pmnum in ('E3485-32')
	AND wonum = '1012565' 
	--AND changeby = 'BRANNTR1' AND changedate >= {ts '2023-08-31 10:00:00.000'} AND changedate <= {ts '2023-08-31 10:30:00.000'}
ORDER BY changedate