USE max76PRD
GO

/******************************************************************************************
Query Name       : ActivePOsNotMaxRevision.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\PO_PR Queries\ActivePOsNotMaxRevision.sql
Author           : Troy Brannon
Date Created     : 2026-01-08
Version          : 1.0

Purpose          : Find all purchase orders with revisions that are active but are NOT 
                   at their maximum revision number. This identifies POs that should likely 
                   be marked as 'REVISD' or cleaned up.

Row Grain        : One row per PO that is active but not at max revision

Assumptions      : 
                   - Active statuses exclude: 'CAN' (Cancelled), 'REVISD' (Revised), 'CLOSE' (Closed)
                   - Each ponum can have multiple revision numbers
                   - The maximum revisionnum for each ponum represents the current version

Parameters       : 
                   - @siteid: Site filter (default: 'FWN')

Filters          : 
                   - status NOT IN ('CAN','REVISD','CLOSE')
                   - revisionnum < MAX(revisionnum) for that ponum

Security         : No sensitive data exposed. Ensure access to po table is properly controlled.

Change Log       : 
                   - 2026-01-08: Initial creation
******************************************************************************************/

-- Declare parameters
DECLARE @siteid VARCHAR(8) = 'FWN';

-- CTE to get maximum revision per PO
WITH MaxRevisions AS (
    SELECT 
        ponum, 
		status,
        MAX(revisionnum) AS max_revision
    FROM dbo.po
    WHERE siteid = @siteid
		AND status NOT IN ('PNDREV')
    GROUP BY ponum, status
)

-- Find POs that are active but not at their max revision and max_revision NOT in a PNDREV status
SELECT 
    p.ponum,
    p.revisionnum,
    mr.max_revision,
    p.status,
    p.statusdate,
	mr.status AS [max_revision status],
    p.description,
    p.orderdate,
    p.vendor,
    p.siteid,
    CAST(mr.max_revision - p.revisionnum AS INT) AS revisions_behind
FROM dbo.po AS p
	INNER JOIN MaxRevisions AS mr
ON p.ponum = mr.ponum
WHERE 
    p.siteid = @siteid
    AND p.status NOT IN ('CAN', 'REVISD', 'CLOSE')
    AND p.revisionnum < mr.max_revision
ORDER BY 
    revisions_behind DESC,
    p.ponum,
    p.revisionnum;
