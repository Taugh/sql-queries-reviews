USE max76PRD
GO

/******************************************************************************************
Query Name       : FixPORevisionStatus.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\PO_PR Queries\FixPORevisionStatus.sql
Author           : Troy Brannon
Date Created     : 2026-01-08
Version          : 1.0

Purpose          : Fix PO revisions where an old revision has incorrect status.
                   Sets status to 'REVISD' and historyflag to 1 for superseded revisions.

******************************************************************************************/

-- Step 1: Verify which revision needs fixing
SELECT 
    ponum,
    revisionnum,
    status,
    historyflag,
    orderdate,
    statusdate,
    description
FROM dbo.po
WHERE ponum = 'YOUR_PO_NUMBER'  -- Replace with actual PO number
    AND siteid = 'FWN'
ORDER BY revisionnum;

-- Step 2: Update the old revision (VERIFY REVISION NUMBER FIRST!)
UPDATE dbo.po
SET status = 'REVISD',
    historyflag = 1,
    statusdate = GETDATE()
WHERE ponum = 'YOUR_PO_NUMBER'  -- Replace with actual PO number
    AND revisionnum = X  -- Replace X with the OLD revision number (NOT the max!)
    AND siteid = 'FWN';

-- Step 3: Verify the fix
SELECT 
    ponum,
    revisionnum,
    status,
    historyflag,
    orderdate,
    statusdate
FROM dbo.po
WHERE ponum = 'YOUR_PO_NUMBER'  -- Replace with actual PO number
    AND siteid = 'FWN'
ORDER BY revisionnum;
