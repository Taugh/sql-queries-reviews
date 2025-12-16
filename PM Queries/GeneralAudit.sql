

/*PM General Audit Info*/
SELECT pmnum
	,gmpcritical
	,adjnextdue
	,assetnum
	,changeby
	,changedate
	,description
	,frequency
	,frequnit
	,jpnum
	,pmnum
	,status
	,worktype
	,eauditusername
	,eaudittimestamp
	,eaudittype
	,esigtransid
	,lastcompdate
	,laststartdate
	,leadtime
	,nextdate
	,ownergroup
	,pmcounter
FROM dbo.a_pm
WHERE pmnum = 'E15413-M' AND siteid = 'FWN'
ORDER BY eaudittimestamp desc;