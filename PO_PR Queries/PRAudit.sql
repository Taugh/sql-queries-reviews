USE max76PRD

SELECT prnum
	,prlinenum
	,itemnum
	,modelnum
	,description
	,enterdate
	,orderqty
	,eauditusername
	,eaudittimestamp
	,eaudittype
FROM dbo.a_prline
WHERE enterdate >= {ts '2024-10-01 00:00:00'} AND enterdate < {ts '2025-01-01 00:00:00'}
--prnum = '58253' 
--AND itemnum = '10042712'
ORDER BY eaudittimestamp
