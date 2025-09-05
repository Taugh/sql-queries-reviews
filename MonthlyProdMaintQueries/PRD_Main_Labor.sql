USE max76PRD

-- Last month's labor on non-inprogress/non-appr WOs for specific owner groups at FWN
-- Row grain: one row per labtrans (Laborcode per WO), not aggregated

DECLARE @StartOfPrevMonth  date = DATEADD(DAY, 1, EOMONTH(GETDATE(), -2)); -- first day prev month
DECLARE @StartOfThisMonth  date = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1)); -- first day current month

SELECT
    w.wonum                 AS [Work Order],
    w.description           AS [WO Description],
    l.laborcode             AS [Labor],
    p.displayname           AS [Name],
    w.siteid                AS [Site],
    w.assignedownergroup    AS [Group],
    w.worktype              AS [Work Type],
    w.status                AS [Status],
    l.startdatetime         AS [Start Date],
    l.finishdatetime        AS [Complete Date],
    l.regularhrs            AS [Time]
FROM dbo.workorder AS w
INNER JOIN dbo.labtrans AS l
    ON  l.refwo  = w.wonum
    AND l.siteid = w.siteid
LEFT JOIN dbo.person AS p
    ON  p.personid      = l.laborcode
    AND p.locationsite  = l.siteid            -- keep if this is correct for your model
WHERE
    w.woclass IN ('WORKORDER', 'ACTIVITY')
    AND w.istask = 0
    AND w.siteid = 'FWN'
    AND w.status NOT IN ('WAPPR', 'APPR', 'INPRG')
    AND w.assignedownergroup IN ('FWNLC1', 'FWNPS', 'FWNLC2', 'FWNMOS')
    AND l.startdatetime  >= @StartOfPrevMonth
    AND l.finishdatetime <  @StartOfThisMonth
ORDER BY
    w.assignedownergroup, l.laborcode, w.worktype, w.wonum;