USE max76PRD

/******************************************************************************************
Query Name      : SentToQAByYear.sql
File Path       : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\QA Reports\SentToQAByYear.sql
Repository     :  https://github.com/Taugh/sql-queries-reviews/tree/main/QA%20Reports/SentToQAByYear.sql
Author          : Troy Brannon
Date Created    : 2025-09-05
Version         : 1.0

Purpose         : Retrieves all work orders that were sent to QA (status = 'PENDQA') 
                  during the previous calendar year.

Row Grain       : One row per work order sent to QA

Assumptions     : 
    - Only status transitions to 'PENDQA' are considered.
    - QA approval is not required for inclusion.

Parameters      : None

Filters         : 
    - siteid = 'FWN'
    - woclass IN ('WORKORDER','ACTIVITY')
    - istask = 0
    - status IN ('FLAGGED','PENRVW','PENDQA','REVWD','CLOSE')
    - changedate within previous year
    - status = 'PENDQA'

Security        : No dynamic SQL or user input. Safe for deployment.

Version Control : Staged for GitHub in 'sql-queries-reviews' repository.

Change Log      : 
    - 2025-09-05: Initial review and header added by Copilot
******************************************************************************************/

;WITH sent_to_qa_year AS (
    SELECT 
        s.wonum,
        s.siteid,
        s.status,
        s.changeby,
        s.changedate
    FROM wostatus AS s
    WHERE s.siteid = 'FWN'
        AND s.status = 'PENDQA'
        AND s.changedate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0)
        AND s.changedate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)
)

SELECT DISTINCT
    w.wonum AS [Work Order],
    w.description AS [Description],
    w.status AS [Current Status],
    s.status AS [Pending Status],
    s.changeby AS [Sent By 521],
    s.changedate AS [Date Sent to QA],
    --l.createby AS [Approved By 521],
    p.displayname AS [Sent By]
FROM workorder AS w
INNER JOIN sent_to_qa_year AS s
    ON w.wonum = s.wonum AND w.siteid = s.siteid
INNER JOIN person AS p
    ON s.changeby = p.personid
INNER JOIN worklog AS l
    ON w.wonum = l.recordkey AND w.siteid = l.siteid
INNER JOIN person AS p1
    ON l.createby = p1.personid
WHERE w.siteid = 'FWN'
    AND w.woclass IN ('WORKORDER', 'ACTIVITY')
    AND w.istask = 0
    AND w.status IN ('FLAGGED', 'PENRVW', 'PENDQA', 'REVWD', 'CLOSE')

