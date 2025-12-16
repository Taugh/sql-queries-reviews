USE max76PRD
GO

--Attemps to recover recently deleted OR unsaved queries
--SELECT execquery.last_execution_time AS [Date Time]
--	,execsql.text AS [Script]
--FROM sys.dm_exec_query_stats AS execquery
--CROSS APPLY sys.dm_exec_sql_text(execquery.sql_handle) AS execsql
--ORDER BY execquery.last_execution_time DESC

--Atemps to recover query FROM specific date range
--SELECT t.query_sql_text
--FROM sys.query_store_query_text t
--INNER JOIN sys.query_store_query q ON t.query_text_id = q.query_text_id
--WHERE q.last_execution_time BETWEEN '2025-01-27' AND '2025-01-28'

--searches the plan cache for queries containing a specific text
SELECT t.[text], s.last_execution_time
FROM sys.dm_exec_cached_plans AS p
INNER JOIN sys.dm_exec_query_stats AS s ON p.plan_handle = s.plan_handle
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
WHERE t.[text] LIKE N'%2022 Downtime%'
ORDER BY s.last_execution_time DESC;