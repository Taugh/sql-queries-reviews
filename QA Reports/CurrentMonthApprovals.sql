USE max76PRD
GO

/******************************************************************************************
Query Name      : CurrentMonthApprovals.sql
File Path       : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\QA Reports\CurrentMonthApprovals.sql
Repository      : https://github.com/Taugh/sql-queries-reviews/tree/main/QA%20Reports/currentmonthapprovals.sql
Author          : Troy Brannon
Date Created    : 2025-09-05
Version         : 1.00

Purpose         : Retrieves work orders that underwent risk assessment AND were approved
                  by QA during the current month.

Row Grain       : One row per work order WITH QA approval log

Assumptions     : 
    - QA approval is logged WITH logtype = 'QA APPROVAL'.
    - Risk assessment is implied by status codes: PENDQA, PENRVW, REVWD.

Parameters      : None

Filters         : 
    - siteid = 'FWN'
    - status IN ('PENDQA','PENRVW','REVWD')
    - woclass IN ('WORKORDER','ACTIVITY')
    - historyflag = 0
    - istask = 0
    - QA approval date in current month
    - logtype = 'QA APPROVAL'

Security        : No dynamic SQL OR user input. Safe for deployment.

Version Control : Staged for GitHub in 'sql-queries-reviews' repository.

Change Log      : 
    - 2025-09-05: Initial review AND header added by Copilot
******************************************************************************************/

WITH qa_status AS (
    SELECT 
        s.wonum,
        s.siteid,
        s.status,
        s.changedate,
        s.changeby
    FROM dbo.wostatus AS s
    WHERE s.siteid = 'FWN'
        AND s.status IN ('PENDQA','PENRVW','REVWD')
)

SELECT 
    w.wonum AS [Work Order],
    w.description AS [Description],
    w.status AS [Current Status],
    qs.status AS [Pending Status],
    qs.changedate AS [Date Sent to QA],
    --qs.changeby AS [Sent By 521],
    --p.displayname AS [Sent By],
    l.createdate AS [Date QA Approved],
    l.createby AS [Approved By 521],
    p1.displayname AS [Approved By Name]
FROM dbo.workorder AS w
INNER JOIN qa_status AS qs
    ON w.wonum = qs.wonum AND w.siteid = qs.siteid
INNER JOIN dbo.person AS p
    ON qs.changeby = p.personid
INNER JOIN dbo.worklog AS l
    ON w.wonum = l.recordkey AND w.siteid = l.siteid
INNER JOIN dbo.person AS p1
    ON l.createby = p1.personid
WHERE w.woclass IN ('WORKORDER','ACTIVITY')
    AND w.historyflag = 0 
    AND w.istask = 0
    AND l.createdate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
    AND l.createdate < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)
    AND l.logtype = 'QA APPROVAL'
