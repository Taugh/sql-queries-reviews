USE max76PRD
GO


SELECT ponum
	,revisionnum
	,status
	,siteid
	,statusdate
	,followupdate
FROM dbo.po
WHERE siteid = 'FWN' AND status = 'APPR'  AND orgid = 'US' AND historyflag = 0 AND followupdate is NULL
	AND revisionnum = (SELECT MAX(revisionnum) 
					   FROM dbo.po po2 
					   WHERE po.siteid = po2.siteid AND po.ponum = po2.ponum 
						AND po2.status NOT in (SELECT value 
											   FROM dbo.synonymdomain 
											   WHERE domainid='POSTATUS' AND maxvalue in ('CAN')
											  )
					   )