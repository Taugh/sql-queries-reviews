USE max76PRD

SELECT
    r.reportname       AS ReportName,
    r.description      AS Description,
    r.appname          AS Application,
    r.lastrundate      AS LastRunDate,
    r.lastrunduration  AS LastRunDuration
FROM dbo.report AS r
ORDER BY
    CASE WHEN r.lastrundate IS NULL THEN 1 ELSE 0 END,
    r.lastrundate DESC;