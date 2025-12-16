USE Max76PRD
GO


SELECT i.itemnum
	
	--,eaudittimestamp
	--,eaudittype
--	,eauditusername
FROM dbo.inventory AS i
	INNER JOIN dbo.invbalances AS b
ON i.siteid = b.siteid AND i.itemnum = b.itemnum
WHERE i.siteid = 'FWN' AND status = 'OBSOLETE' AND statusdate >= DATEADD(month, datediff(month,0,getdate())-9,0) 
	--AND eauditusername in ('BRANNTR1')
