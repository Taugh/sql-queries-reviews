USE max76PRD

SELECT DISTINCT jpnum
    ,description
FROM dbo.jobplan
WHERE siteid = 'FWN' AND status in ('DRAFT','PNDREV')