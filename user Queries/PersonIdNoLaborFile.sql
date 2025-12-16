USE max76PRD
GO

/* ============================================================================
Query Name       : Active Persons Missing Labor OR User Profiles
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\User Queries\PersonIdNoLaborFile.sql

Purpose          : Identifies active persons at site FWN who lack labor profiles OR user records, excluding management titles.

Row Grain        : One row per person missing labor OR user profile

Assumptions      : Titles containing 'Manager' OR matching specific roles are excluded; laborcode AND personid null checks indicate missing profiles

Parameters       : None

Filters          : status = 'ACTIVE', locationsite = 'FWN', title exclusions, laborcode IS NULL, personid IS NULL

Security         : Ensure access to person, labor, AND maxuser tables is restricted

Version Control  : https://github.com/Taugh/sql-queries-reviews/blob/main/User%20Queries/PersonIdNoLaborFile.sql

Change Log       : 2025-09-08, Brannon, Troy – Initial review AND refactor
============================================================================ */

-- Query 1: Looks for person IDs WITH no labor profile
SELECT 
    p.personid AS [Person ID],
    p.status AS [Status],
    p.firstname AS [First Name],
    p.lastname AS [Last Name],
    p.title AS [Title],
    p.supervisor AS [Supervisor],
    l.personid AS [Labor]
FROM dbo.person AS p
LEFT JOIN dbo.labor AS l
    ON p.personid = l.personid
INNER JOIN dbo.maxuser AS m
    ON p.personid = m.personid
WHERE 
    p.status = 'ACTIVE'
    AND p.locationsite = 'FWN'
    AND l.laborcode IS NULL
    AND p.title NOT IN (
        'Supervisor', 'Supv', 'Mfg Production', 'Manager', 
        'Senior Manager', 'Analytical Sci'
    )
    AND p.title NOT LIKE '%Manager%'
    AND NOT EXISTS (
        SELECT 1
        FROM dbo.maxuser
        WHERE personid = l.personid
    )
ORDER BY 
    p.supervisor;

-- Query 2: Looks for person IDs WITH no user profile
SELECT 
    p.personid AS [Person ID],
    p.status AS [Status],
    p.firstname AS [First Name],
    p.lastname AS [Last Name],
    p.title AS [Title],
    p.supervisor AS [Supervisor],
    l.personid AS [User],
    l.status AS [User Status]
FROM dbo.person AS p
LEFT JOIN dbo.maxuser AS l
    ON p.personid = l.personid
WHERE 
    p.status = 'ACTIVE'
    AND p.locationsite = 'FWN'
    AND l.personid IS NULL
    AND p.title NOT IN (
        'Supervisor', 'Supv', 'Mfg Production', 'Manager', 
        'Senior Manager', 'Analytical Sci'
    )
    AND p.title NOT LIKE '%Manager%';
