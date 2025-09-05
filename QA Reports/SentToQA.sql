USE max76PRD
GO

/******************************************************************************************
Query Name      : SentToQA.sql
File Path       : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\QA Reports\SentToQA.sql
Author          : Troy Brannon
Date Created    : 2025-09-05
Version         : 1.0

Purpose         : Retrieves all work orders that were sent to QA (status = 'PENDQA') 
                  during the previous calendar month.

Row Grain       : One row per work order sent to QA

Assumptions     : 
    - Only status transitions to 'PENDQA' are considered.
    - QA approval is not required for inclusion.

Parameters      : None

Filters         : 
    - siteid = 'FWN'
    - woclass IN ('WORKORDER','ACTIVITY')
    - historyflag = 0
    - istask = 0
    - status = 'PENDQA'
    - changedate within previous month

Security        : No dynamic SQL or user input. Safe for deployment.

Version Control : Staged for GitHub in 'sql-queries-reviews' repository.

Change Log      : 
    - 2025-09-05: Initial review and header added by Copilot
******************************************************************************************/

WITH sent_to_qa AS (
    SELECT 
        s.wonum,
        s.siteid,
        s.status,
        s.changeby,
        s.changedate
    FROM wostatus AS s
    WHERE s.siteid = 'FWN'
        AND s.status = 'PENDQA'
        AND s.changedate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP) - 1, 0)
        AND s.changedate < DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0)
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
INNER JOIN sent_to_qa AS s
    ON w.wonum = s.wonum AND w.siteid = s.siteid
INNER JOIN person AS p
    ON s.changeby = p.personid
INNER JOIN worklog AS l
    ON w.wonum = l.recordkey AND w.siteid = l.siteid
INNER JOIN person AS p1
    ON l.createby = p1.personid
WHERE w.siteid = 'FWN'
    AND w.woclass IN ('WORKORDER', 'ACTIVITY')
    AND w.historyflag = 0
    AND w.istask = 0
    AND w.status IN ('FLAGGED', 'PENRVW', 'PENDQA', 'REVWD')
