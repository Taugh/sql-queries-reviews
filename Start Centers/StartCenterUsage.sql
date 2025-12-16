USE max76PRD

--Locate start Center(s) for user(S)
SELECT * 
FROM dbo.scconfig 
WHERE userid = 'BRANNTR1'
	--AND description = 'FWN Maintenance Tech' 
ORDER BY description;