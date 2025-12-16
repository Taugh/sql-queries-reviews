USE max76PRD

--You will be able figure who (USERID column) is modifying the template (DESCRIPTION column)
SELECT * 
FROM dbo.scconfig 
WHERE description = 'FWN Maintenance Tech' 
	AND groupname is null;

