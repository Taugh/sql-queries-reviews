USE max76PRD
GO

SELECT itemnum
	,description
	,eauditusername
	,eaudittype
	,eaudittimestamp
FROM dbo.a_item	
WHERE itemnum like '10002167' --AND eaudittype = 'I'
ORDER BY eaudittimestamp desc;
