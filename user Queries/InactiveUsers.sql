USE max76PRD

/* ============================================================================
Query Name       : InactiveUsers.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\User Queries
				  \InactiveUsers.sql

Purpose          : Identifies active users at site 'FWN' who haven't logged in for 120+ days 
				  AND flags them for retraining before reactivation.

Row Grain        : One row per qualifying user

Assumptions      : TIMEOUT attempts are excluded; users WITH no login OR outdated login are considered inactive

Parameters       : None

Filters          : defsite = 'FWN', status = 'ACTIVE', sysuser = 0, userid NOT IN ('MAXADMIN', 'PUBLICQUERIESFWN', 'MXINTADM')

Security         : Ensure access to logintracking AND user status tables is restricted

Version Control  : https://github.com/[your-org]/sql-queries-reviews/blob/main/User Queries/InactiveUsers.sql

Change Log       : 2025-09-08, Brannon, Troy – Initial review AND refactor
============================================================================ */

-- Include the following in the Status change Memo: 'Requires retraining before reactivation.'
;WITH maxattempt AS (
    SELECT 
        userid, 
        MAX(attemptdate) AS maxdate
    FROM dbo.logintracking
    WHERE attemptresult != 'TIMEOUT'
    GROUP BY userid
    HAVING MAX(attemptdate) IS NULL 
        OR MAX(attemptdate) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()) - 120, 0)
),

maxStatus AS (
    SELECT 
        userid, 
        MAX(changedate) AS statusdate
    FROM dbo.maxuserstatus
    GROUP BY userid
)

SELECT DISTINCT 
    m.userid,
    p.displayname,
    ISNULL(a.maxdate, 0) AS LastLogin,
    s.statusdate
FROM dbo.maxuser AS m
INNER JOIN maxattempt AS a
    ON m.userid = a.userid
INNER JOIN dbo.person AS p
    ON m.personid = p.personid
INNER JOIN maxStatus AS s
    ON m.userid = s.userid
WHERE 
    m.defsite = 'FWN'
    AND m.status = 'ACTIVE'
    AND m.sysuser = 0
    AND m.userid NOT IN ('MAXADMIN', 'PUBLICQUERIESFWN', 'MXINTADM');
