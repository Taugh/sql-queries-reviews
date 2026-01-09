USE max76PRD

-- First, verify assets are decommissioned and have spart parts assigned
SELECT *
FROM dbo.sparepart
WHERE siteid = 'FWN'
	AND assetnum IN ('9085','9086','9108','9246','9290','9303','9306','9307','9372','9377','9388','940','9424','9556','9558','9818','9819','9876');

-- Then delete parts from asset spare part list
DELETE
FROM dbo.sparepart
WHERE siteid = 'FWN'
	AND assetnum IN ('9085','9086','9108','9246','9290','9303','9306','9307','9372','9377','9388','940','9424','9556','9558','9818','9819','9876');