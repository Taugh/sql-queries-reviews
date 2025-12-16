USE max76PRD
GO


SELECT DISTINCT j.jpnum AS 'Job Plan'
	,j.description AS Description
	,MAX(pluscrevnum) AS 'Revision #'
	,p.ownergroup AS 'Owner Group'
FROM dbo.jobplan AS j
	INNER JOIN dbo.pm AS p
ON j.jpnum = p.jpnum AND p.siteid = j.siteid
WHERE p.siteid = 'FWN' AND p.status = 'ACTIVE' AND p.ownergroup in ('FWNCSM','FWNWSM','FWNMET') 
GROUP BY j.jpnum, j.description, p.ownergroup
ORDER BY [Owner Group], [Job Plan];