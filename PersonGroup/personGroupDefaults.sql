USE max76PRD
GO


SELECT persongroup
	,respparty
	,p.displayname
FROM dbo.persongroupteam AS g
	INNER JOIN dbo.person AS p
ON g.resppartygroup = p.personid
WHERE persongroup like 'FWN%' AND groupdefault = 1 AND persongroup NOT in ('FWN-FACM','FWN-STER')