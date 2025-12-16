USE max76PRD
GO

--Returnd audit trail for record entered
SELECT 
DISTINCT pmnum
	,description
	,leadtime
	,assetnum
	,location
	,jpnum
	,status
	,laststartdate
	,lastcompdate
	,nextdate
	,stconoffset
	,fnconoffset
	,frequency
	,frequnit
	,eauditusername
	,eaudittimestamp
	,eaudittype
	,owner
	,ownergroup
	,assignedownergroup
	,supervisor
 FROM dbo.a_pm
WHERE siteid = 'FWN' 
--AND status in ('ACTIVE') 
	--AND assetnum is null
	--AND location is null
	--AND eaudittimestamp > DATEADD(year, -5, getdate())
	--AND eaudittype = 'I'
	--AND jpnum = 'JP2216' 
	AND pmnum in ('E10705 -1Y','E15330-3M','E17365 -1Y')  
	--AND frequnit = 'YEARS' AND frequency = '1'
	--AND nextdate <= dateadd(month,datediff(month,0,getdate())-12,+0) 
ORDER BY pmnum, eaudittimestamp desc;