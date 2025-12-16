USE max76PRD


SELECT
    reportname AS [Report Name],
    description AS [Description],
    appname AS [Application],
    r.userid AS [Created By],
    defsite AS [Creator Site ID],
    lastrundate AS [Last Run Timestamp],
    lastrunby AS [Last Run By]
FROM dbo.report AS r
    LEFT JOIN dbo.maxuser AS mu 
ON r.userid = mu.userid
WHERE 
    r.userid NOT IN ('MAXADMIN', 'MAXIMO', 'MXINTADM', 'MXESADMIN') -- Exclude OOB/system users
	AND lastrundate < DATEADD(YEAR,DATEDIFF(YEAR,0,CURRENT_TIMESTAMP)-2, 0)
ORDER BY 
    [Creator Site ID];
