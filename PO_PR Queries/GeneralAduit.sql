USE max76PRD
GO

--Returns audit information for specified POs
SELECT ponum
	,status
	,statusdate
	,revisionnum
	,changeby
	,changedate
	,receipts
	,eaudittimestamp
	,eauditusername
	,eaudittype
FROM dbo.a_po
WHERE siteid = 'FWN' 
	--AND orderdate >= DATEADD(MONTH, -10, getdate()) 
	--AND eaudittype = 'I'
	AND ponum = '44352'
	--AND revisionnum in ('34','35')
ORDER BY revisionnum, eaudittimestamp

--Returns audit information for specified PRs
--SELECT ponum
	-- ,status
	-- ,statusdate
	-- ,revisionnum
	-- ,changeby
	-- ,changedate
	-- ,receipts
	-- ,eaudittimestamp
	-- ,eauditusername
	-- ,eaudittype
--FROM dbo.a_pr
--WHERE siteid = 'FWN' AND prnum in ('51764','51767');