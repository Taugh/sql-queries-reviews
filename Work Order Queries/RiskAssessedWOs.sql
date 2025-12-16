USE max76PRD

/*========================================================================================================================
  Query Name      : RiskAssessedWOs.sql
  File Path       : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\Work Order Queries/RiskAssessedWOs.sql
  
  Purpose         : Retrieves all reviewed OR closed PM work orders at site FWN that include either a QA approval
                    OR risk assessment log entry, to identify patterns in formally documented PM tasks.
  
  Row Grain       : One row per qualifying PM work order.
  
  Assumptions     : Only work orders WITH QA OR risk logs are considered. Status must be 'REVIEW' OR 'CLOSE'.
  
  Parameters      : None (static filter for siteid = 'FWN')
  
  Filters         : siteid = 'FWN', woclass IN ('WORKORDER','ACTIVITY'), istask = 0,
  
                    worktype = 'PM', status IN ('REVIEW','CLOSE'), logtype IN ('QA APPROVAL','RISK ASSESSMENT')
  
  Security        : No dynamic SQL OR user input. Safe for production.
  
  Version Control : https://github.com/Taugh/sql-queries-reviews/blob/main/Work%20Order%20Queries/RiskAssessedWOs.sql
  
  Change Log      : 2025-09-08 - Removed TOP 3 limit; updated documentation header
========================================================================================================================*/

SELECT
    w.wonum AS [Work Order],
    w.description AS [Description],
    w.siteid AS [Site],
    w.status AS [Status],
    w.worktype AS [Work Type],
    w.assignedownergroup AS [Owner Group],
    w.owner AS [Owner],
    w.assetnum AS [Asset Number],
    w.location AS [Location],
    w.pmnum AS [PM Number],
    w.targcompdate AS [Target Due Date]
FROM dbo.workorder AS w
WHERE w.siteid = 'FWN'
  AND w.woclass IN ('WORKORDER','ACTIVITY')
  AND w.istask = 0
  AND w.worktype = 'PM'
  AND w.status IN ('REVIEW', 'CLOSE')
  AND EXISTS (
      SELECT 1
      FROM dbo.worklog
      WHERE worklog.siteid = w.siteid
        AND worklog.recordkey = w.wonum
        AND worklog.logtype IN ('QA APPROVAL', 'RISK ASSESSMENT')
  )
ORDER BY w.reportdate DESC;

