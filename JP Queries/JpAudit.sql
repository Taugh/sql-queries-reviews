USE max76PRD
GO


SELECT jpnum
	,description
	,status
	,siteid
	,revision
	,eaudittimestamp
	,eauditusername
	,eaudittype
FROM dbo.a_jobplan
WHERE siteid = 'FWN' AND jpnum in ('JP2306-02')
