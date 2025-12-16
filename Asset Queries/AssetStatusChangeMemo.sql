USE Max76PRD
GO


SELECT assetnum
    ,status
    ,memo
FROM dbo.PLUSCASSETSTATUS
WHERE siteid = 'FWN' AND assetnum = '6988'
