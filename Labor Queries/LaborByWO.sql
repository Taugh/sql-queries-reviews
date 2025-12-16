USE max76PRD
GO

--Returns labor transaction record for specified work order
SELECT personid
	,laborcode
	,displayname
	,refwo
FROM dbo.labtrans
WHERE siteid in ('ASPEX','FWN')
	AND laborcode in ('GONZAST1')
	--AND refwo = '1039318';
ORDER BY enterdate desc