USE max76PRD
GO

/*========================================================================================================================
  Query Name      : WorkLog.sql
  File Path       : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\WorkLog\WorkLog.sql
 
  Purpose         : Returns the most recent worklog entry for a specified work order at site ASPEX, including full log
                    details. Useful for reviewing the latest technician notes, QA approvals, OR risk assessments.
 
  Row Grain       : One row per work order (latest log entry only)
 
  Assumptions     : Worklog entries are uniquely identified by worklogid. Latest entry is determined by MAX(worklogid).
 
  Parameters      : recordkey = '451552' (can be modified to generalize)
 
  Filters         : siteid = 'ASPEX', recordkey = '451552'
 
  Security        : No dynamic SQL OR user input. Safe for production.
 
  Version Control : https://github.com/Taugh/sql-queries-reviews/blob/main/WorkLog/WorkLog.sql
 
  Change Log      : 2025-09-08 - Initial review AND refactor by Copilot
========================================================================================================================*/

SELECT 
    l.*
FROM dbo.worklog AS l
INNER JOIN (
    SELECT 
        recordkey,
        MAX(worklogid) AS logid
    FROM dbo.worklog
    WHERE siteid = 'ASPEX'
    GROUP BY recordkey
) AS wl
    ON l.recordkey = wl.recordkey 
    AND l.worklogid = wl.logid
WHERE l.siteid = 'ASPEX'
	AND l.recordkey = '451552'
	-- Optional filter to exclude QA logs:
	-- AND l.logtype != 'QA APPROVAL'
ORDER BY l.worklogid DESC;
