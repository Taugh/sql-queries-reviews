USE max76PRD
GO

/* ============================================================================
Query Name       : Users with Last Login Over 90 Days
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\User Queries\QuarterlyInactiveUserReview.sql
Purpose          : Identifies active users at site FWN who have not logged in for over 90 days or have never logged in.
Row Grain        : One row per user
Assumptions      : Each user has a unique personid and userid; sysuser = 0 excludes system accounts
Parameters       : None
Filters          : status = 'ACTIVE', defsite = 'FWN', sysuser = 0, last login > 90 days or NULL
Security         : Ensure access to logintracking and user tables is restricted
Version Control  :  https://github.com/Taugh/sql-queries-reviews\blob/main/user%20Queries/QuarterlyInactiveUserReview.sql
Change Log       : 2025-09-08, Brannon, Troy – Initial review and refactor
============================================================================ */

SELECT DISTINCT 
    m.personid AS [PersonID],
    p.displayname AS [Name],
    MAX(l.attemptdate) AS [Last Login]
FROM maxuser AS m
INNER JOIN person AS p
    ON m.personid = p.personid
INNER JOIN logintracking AS l
    ON m.userid = l.userid
WHERE 
    m.status = 'ACTIVE'
    AND m.defsite = 'FWN'
    AND m.sysuser = 0
GROUP BY 
    m.personid, p.displayname
HAVING 
    MAX(l.attemptdate) IS NULL
    OR MAX(l.attemptdate) < DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()) - 90, 0)
ORDER BY 
    m.personid,
    [Last Login] DESC;
