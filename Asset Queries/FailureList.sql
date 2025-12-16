USE max76PRD
GO


SELECT failurelist
	,failurecode
	,parent
	,type
	,orgid
FROM dbo.failurelist
WHERE orgid = 'US'