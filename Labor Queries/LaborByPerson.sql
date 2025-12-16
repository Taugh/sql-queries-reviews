USE max76PRD
GO

--Returns labor record for sprcified person
SELECT personid
    ,laborcode
    ,displayname
FROM dbo.labor
WHERE laborcode in ('SOSAGE3');