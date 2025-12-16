USE max76PRD
GO

SELECT s.itemnum
	,curbal
	,s.assetnum
FROM dbo.sparepart AS s
	INNER JOIN dbo.invbalances AS b
ON s.siteid = b.siteid AND s.itemnum = b.itemnum
WHERE s.siteid = 'FWN' AND assetnum in ('2151','10467','1026','10470')
ORDER BY s.itemnum;