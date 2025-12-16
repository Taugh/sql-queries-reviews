USE max76PRD
GO

SELECT pmnum
	,description
	,assetnum
	,status
	,worktype
	,frequency
	,frequnit
	,leadtime
	,stconoffset
	,fnconoffset
	,nextdate
	,assignedownergroup
FROM dbo.pm
WHERE siteid = 'ASPEX' 
	AND frequnit = 'YEARS' 
	--AND frequency >= '6' 
	AND status = 'ACTIVE' 
	--AND worktype != 'RQL' 
	--AND (leadtime is null OR stconoffset is null OR fnconoffset is null)
ORDER BY assignedownergroup;