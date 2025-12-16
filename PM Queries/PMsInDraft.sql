USE max76PRD

SELECT pmnum
    ,description
    ,assetnum
    ,status
    ,worktype
    ,frequency
    ,frequnit
    ,leadtime
    ,stconoffset
    ,fnconoffset
    ,nextdate
FROM dbo.pm
WHERE siteid = 'FWN' AND status = 'DRAFT'