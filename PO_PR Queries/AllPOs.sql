USE max76PRD
GO


SELECT ponum
	,description
	,orderdate
	,requireddate
	,followupdate
	,status
	,statusdate
	,vendor
	,siteid
	,receipts
FROM dbo.po
WHERE siteid = 'FWN' AND status NOT IN ('CAN','REVISD')