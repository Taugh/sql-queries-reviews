USE max76PRD
GO

--Counts all scheduled maintenance work orders that are NOT in a complete status	
SELECT p.persongroup AS 'Owner Group'
	,COUNT(w.wonum) AS 'Total Work Orders'
FROM dbo.persongroup AS p
	INNER JOIN dbo.workorder AS w
ON p.persongroup = w.assignedownergroup
WHERE p.persongroup like 'FWN%' AND (w.woclass in ('WORKORDER','ACTIVITY')) AND w.historyflag  =  0 AND w.istask  =  0 AND w.siteid  = 'FWN' 
	AND (w.worktype in ('CA','PM','RM','RQL')) AND status in ('WAPPR','APPR','INPRG')
GROUP BY p.persongroup




