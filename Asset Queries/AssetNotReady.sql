USE max76PRD

SELECT assetnum AS Asset
    ,description AS Description
    ,location AS Location
    ,status AS Status
FROM dbo.asset
WHERE siteid = 'FWN' AND status = 'NOT READY' AND assettype != 'METROLOGY'