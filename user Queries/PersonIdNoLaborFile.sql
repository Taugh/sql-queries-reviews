USE max76PRD
GO

/* ============================================================================
Query Name       : Active Persons Missing Labor or User Profiles
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\User Queries\PersonIdNoLaborFile.sql

Purpose          : Identifies active persons at site FWN who lack labor profiles or user records, excluding management titles.

Row Grain        : One row per person missing labor or user profile

Assumptions      : Titles containing 'Manager' or matching specific roles are excluded; laborcode and personid null checks indicate missing profiles

Parameters       : None

Filters          : status = 'ACTIVE', locationsite = 'FWN', title exclusions, laborcode IS NULL, personid IS NULL

Security         : Ensure access to person, labor, and maxuser tables is restricted

Version Control  : https://github.com/Taugh/sql-queries-reviews/blob/main/User%20Queries/PersonIdNoLaborFile.sql

Change Log       : 2025-09-08, Brannon, Troy – Initial review and refactor
============================================================================ */

-- Query 1: Looks for person IDs with no labor profile
SELECT 
    p.personid AS [Person ID],
    p.status AS [Status],
    p.firstname AS [First Name],
    p.lastname AS [Last Name],
    p.title AS [Title],
    p.supervisor AS [Supervisor],
    l.personid AS [Labor]
FROM person AS p
LEFT JOIN labor AS l
    ON p.personid = l.personid
INNER JOIN maxuser AS m
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
        FROM maxuser
        WHERE personid = l.personid
    )
ORDER BY 
    p.supervisor;

-- Query 2: Looks for person IDs with no user profile
SELECT 
    p.personid AS [Person ID],
    p.status AS [Status],
    p.firstname AS [First Name],
    p.lastname AS [Last Name],
    p.title AS [Title],
    p.supervisor AS [Supervisor],
    l.personid AS [User],
    l.status AS [User Status]
FROM person AS p
LEFT JOIN maxuser AS l
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
