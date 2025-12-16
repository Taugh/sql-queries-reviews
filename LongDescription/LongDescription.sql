USE max76PRD
GO

--Returns long description FROM ldkey
-- ldkey is found by quering the main table. EX, to get the long description out of the job tasks for a job plan query the table JOBTASK for JOBTASKID
--Owner table is FROM the main reacord table WHERE is WHERE the long description seen in Maximo 

SELECT ldkey
	,ldtext
FROM dbo.longdescription
WHERE ldownertable = 'WORKORDER' 
	--AND ldtext like N'%Line 10 Conference room%' 
	AND ldkey in ('476255','471684','471683') 
ORDER BY ldkey										
--OFFSET 0 ROWS FETCH FIRST 50 ROWS ONLY;