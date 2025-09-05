USE max76PRD

/******************************************************************************************
Query Name       : ItemsByPOLinesAmdPRLines.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\ItemsByPOLinesAndPRLines.sql
Repository       :https://github.com/Taugh/sql-queries-reviews/tree/main/PO_PR%20Queries\ItemsByPOLinesAndPRLines.sql
Author           : Troy Brannon
Created          : 2025-09-05
Version          : 1.0

Purpose          : Compare purchase order lines with corresponding purchase requisition lines
                   for open POs at a specific site and location. Filters out completed and
                   closed orders.

Row Grain        : One row per itemnum per PO line.

Assumptions      : 
                   - Only active POs are considered (not canceled, closed, revised, etc.).
                   - Receipts must not be marked as complete.
                   - Site ID is hardcoded but can be parameterized.

Parameters       : 
                   - @siteid: Site filter (e.g., 'FWN').

Filters          : 
                   - siteid = @siteid
                   - PO status NOT IN ('CAN','CLOSE','PNDREV','REVISD')
                   - PO receipts != 'COMPLETE'
                   - PO line receiptscomplete = 0

Security         : No sensitive data exposed. Ensure access to po, poline, and prline tables
                   is properly controlled.

Version Control  : Stored in GitHub repository 'sql-queries-reviews'
                   Link: https://github.com/Taugh/sql-queries-reviews/tree/main/PO_PR%20Queries\ItemsByPOLinesAndPRLines.sql
                   Branch: main
                   Last Reviewed: 2025-09-05 by Troy Brannon

Change Log       : 
                   - 2025-09-05: Refactored for clarity, modularity, and maintainability.
******************************************************************************************/

-- Declare site parameter
DECLARE @siteid VARCHAR(8) = 'FWN';

-- CTE to isolate valid PO lines
WITH ValidPO AS (
    SELECT ponum, siteid
    FROM po
    WHERE siteid = @siteid
      AND status NOT IN ('CAN','CLOSE','PNDREV','REVISD')
      AND receipts != 'COMPLETE'
)

SELECT 
    l.itemnum,
    p.ponum,
    l.orderqty AS [PO Qty],
    r.prnum,
    r.orderqty AS [PR Qty]
FROM ValidPO AS p
INNER JOIN poline AS l
    ON p.ponum = l.ponum AND p.siteid = l.siteid
INNER JOIN prline AS r
    ON p.ponum = r.ponum AND p.siteid = r.siteid
WHERE l.receiptscomplete = 0;
