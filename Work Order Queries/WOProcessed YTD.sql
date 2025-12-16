USE max76PRD
GO


SELECT DISTINCT wonum
	,description
	,assetnum
	,location
	,worktype
	,reportdate
	,targcompdate
	,actfinish
	,status
	,owner
FROM dbo.workorder
WHERE siteid = 'ASPEX' AND changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-10, 0) AND changeby = 'BRANNTR1' 
	--OR (siteid = 'FWN' AND changedate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-10, 0) AND changeby = 'MAXADMIN' AND status = 'CLOSE' AND worktype != 'AD')
ORDER BY changedate;