USE Max76PRD
GO

--Returns all PM for maintenance that have a frequency unit of months
SELECT pmnum
	,leadtime
	,ownergroup
	,assignedownergroup
	,frequency
	,frequnit
	,stconoffset
	,fnconoffset
	,nextdate
FROM dbo.pm
WHERE siteid = 'FWN' AND status = 'ACTIVE' AND frequnit NOT in ('DAYS','WEEKS','YEARS')
	AND (ownergroup in ('FWNAE','FWNCMS','FWNLC1','FWNMET','FWNMOS','FWNPS','FWNWSM')
	OR assignedownergroup in ('FWNAE','FWNCMS','FWNLC1','FWNMET','FWNMOS','FWNPS','FWNWSM'))
ORDER BY pmnum;

-- Find all assets WHERE specified item are spare parts
SELECT a.assetnum
	,a.description
	,a.location
	,a.status
	,i.itemnum
	,it.description
	,i.status
	,i.location
	,i.binnum
FROM dbo.asset AS a
	INNER JOIN dbo.sparepart AS sp
ON a.assetnum = sp.assetnum
	INNER JOIN dbo.inventory AS i
ON sp.itemnum = i.itemnum
	INNER JOIN dbo.item AS it
ON i.itemnum = it.itemnum
WHERE a.siteid = 'FWN' AND i.siteid = 'FWN' AND i.location = 'FWNCS' 
	AND i.itemnum in ('106669','106670','106671','106672','106673')
ORDER BY i.itemnum, a.assetnum;

--Returns specified assets
SELECT assetnum
	,description
	,location
	,status
FROM dbo.asset
WHERE assetnum in ('2110','430','787','940','SUPPLIES','10333','10916','5718')
	  AND siteid = 'FWN'
