USE max76PRD
GO


/*--------------------------------------------------------------------------------------------------
Query Name  : ValidationAnnualRequalList.sql
File Path: C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\RQLQueries/ValidationAnnualRequalList.sql
Repository  : https://github.com/Taugh/sql-queries-reviews/tree/main/RQLQueries/ValidationAnnualRequalList.sql
Author      : Troy Brannon
Date        : 2025-09-05
Version     : 1.0

Purpose:
Returns all requalification PMs due within the next calendar year OR recently completed (within 3 months),
filtered by specific job plans AND owner group.

Row Grain:
One row per PM record, optionally joined to a work order if one exists.

Assumptions:
- Only PMs WITH specific job plans are relevant.
- Only assets WITH status ACTIVE OR OPERATING are considered.
- Site is fixed to 'FWN'.

Parameters:
- Current date is used to calculate date ranges.
- Owner group is fixed to 'FWNVAL'.

Filters:
- PMs must be ACTIVE AND belong to 'FWNVAL'.
- Job plans must match the specified list.
- Assets must be ACTIVE OR OPERATING.
- Work orders must be open AND within the next year.

Security:
- No user-specific filters applied. Assumes access to PM, Asset, AND Workorder tables.

Version Control:
- Stored in GitHub under 'sql-queries-reviews' repository.

Change Log:
- 2025-09-05: Initial refactor AND documentation header added by Copilot.
--------------------------------------------------------------------------------------------------*/

SELECT DISTINCT
    p.pmnum AS [PM Number],
    p.assetnum AS [Equipment],
    a.description AS [Equipment Description],
    p.jpnum AS [Job Plan],
    p.ownergroup AS [Owner Group],
    ISNULL(w.wonum, '') AS [Work Order],
    ISNULL(a.eq2, '') AS [Protocol Number],
    ISNULL(p.laststartdate, '') AS [Last Complete Date],
    ISNULL(p.lastcompdate, '') AS [Completion Due Date],
    p.nextdate AS [Earliest Next Due Date],
    p.frequency AS [Frequency in Years]
FROM dbo.pm p
INNER JOIN dbo.asset a
    ON p.assetnum = a.assetnum
LEFT JOIN (
    SELECT
        wonum,
        pmnum,
        MAX(CONVERT(varchar(10), targcompdate, 120)) AS [Completion Due Date]
    FROM dbo.workorder
    WHERE siteid = 'FWN'
      AND targcompdate > DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
      AND targcompdate <= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0)
      AND woclass IN ('WORKORDER', 'ACTIVITY')
      AND historyflag = 0
      AND istask = 0
      AND status NOT IN ('COMP', 'MISSED', 'PENRVW', 'PENDQA', 'FLAGGED', 'REVWD')
      AND assignedownergroup = 'FWNVAL'
    GROUP BY wonum, pmnum
) w ON w.pmnum = p.pmnum
WHERE
    p.siteid = 'FWN'
    AND p.status = 'ACTIVE'
    AND p.ownergroup = 'FWNVAL'
    AND p.jpnum IN (
        'JP0110','RQLAB','RQPKG','JP1691','RQOTH','RQIT','RQSIP',
        'RQFLTR','RQSTRZ','RQUTL','RQCLN','RQWSH','RQ MIC OVEN'
    )
    AND (
        -- PMs due next year
        p.nextdate > DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0)
        AND p.nextdate <= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 2, 0)
        -- OR PMs completed in last 3 months
        OR p.laststartdate > DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 3, 0)
    )
    AND a.status IN ('ACTIVE', 'OPERATING')
    AND a.siteid = 'FWN';
