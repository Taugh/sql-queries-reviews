USE Max76PRD
GO


/* ============================================================================
Query Name       : FindLast3WOs.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\Work Order Queries/FindLast3WOs.sql

Purpose          : Retrieve the last 3 reviewed or closed Preventive Maintenance (PM) work orders at site FWN 
				   that include either a valid risk assessment or QA approval log, in order to identify potential 
				   patterns of incomplete tasks or recurring issues with work order execution.

Row Grain        : One row per qualifying work order

Assumptions      : Frequency units are consistent; worklog entries are properly linked by wonum and siteid

Parameters       : None

Filters          : siteid = 'FWN', status IN ('REVWD','CLOSED'), woclass IN ('WORKORDER','ACTIVITY'), istask = 0, 
				   worktype = 'PM', frequency-based date filters, worklog type IN ('RISK ASSESSMENT','QA APPROVAL')

Security         : Ensure access to workorder and worklog tables is restricted

Version Control  : https://github.com/Taugh/sql-queries-reviews/tree/main/Work%20Order%20Queries/FindLast3WOs.sql

Change Log       : 2023-09-08, Brannon, Troy – Initial review and refactor
============================================================================ */

SELECT 
    wonum,
    assetnum,
    pmnum,
    worktype
FROM workorder
WHERE 
    siteid = 'FWN'
    AND status IN ('REVWD', 'CLOSED')
    AND woclass IN ('WORKORDER', 'ACTIVITY')
    AND istask = 0
    AND (
        -- Monthly PMs (1–5 months, last 3 months)
        (targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
         AND pluscfrequency BETWEEN 1 AND 5
         AND pluscfrequnit = 'MONTHS')
        
        -- Biannual PMs (6–11 months, last 24 months)
        OR (targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 24, 0)
            AND pluscfrequency BETWEEN 6 AND 11
            AND pluscfrequnit = 'MONTHS')
        
        -- Weekly/Daily PMs (1–14 days/weeks, last 3 weeks)
        OR (targcompdate >= DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()) - 3, 0)
            AND pluscfrequency BETWEEN 1 AND 14
            AND pluscfrequnit IN ('DAYS', 'WEEKS'))
        
        -- Annual PMs (1–6 years, last 3 years)
        OR (targcompdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 3, 0)
            AND pluscfrequency BETWEEN 1 AND 6
            AND pluscfrequnit = 'YEARS')
    )
    AND EXISTS (
        SELECT 1
        FROM worklog
        WHERE 
            worklog.recordkey = workorder.wonum
            AND worklog.siteid = workorder.siteid
            AND logtype IN ('RISK ASSESSMENT', 'QA APPROVAL')
    )
ORDER BY 
    pmnum,
    assetnum;
