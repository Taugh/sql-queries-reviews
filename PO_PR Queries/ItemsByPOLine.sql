USE max76PRD

/******************************************************************************************
Query Name       : ItemsByPOLine.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\PO_PR Queries\ItemsByPOLine.sql
Repository       : https://github.com/Taugh/sql-queries-reviews/tree/main/PO_PR Queries/ItemsByPOLine.sql
Author           : Troy Brannon
Date Created     : 2025-09-05
Version          : 1.0

Purpose          : Retrieve purchase order details for Allen-Bradley items ordered in the 
                   current year. Filters by site, location, manufacturer aliases, AND description.

Row Grain        : One row per unique ponum AND polinenum.

Assumptions      : 
                   - Only current-year purchase orders are considered.
                   - Manufacturer aliases are stored in a table variable.
                   - Only latest revision of each PO is selected via CTE.
                   - Store location must match inventory location for JOIN.

Parameters       : 
                   - @StartOfYear: Beginning of the current year.
                   - @siteid: Site filter (e.g., 'FWN').
                   - @storeloc: Store location filter (e.g., 'FWNCS').

Filters          : 
                   - siteid = @siteid
                   - storeloc = @storeloc
                   - orderdate >= @StartOfYear
                   - manufacturer IN (aliases) OR description LIKE '%ALLEN BRADLEY%'
                   - Only latest revisionnum per ponum is retained

Security         : No sensitive data exposed. Ensure access to po, poline, AND inventory 
                   tables is properly controlled.

Version Control  : Stored in GitHub repository 'sql-queries-reviews'
                   Link: https://github.com/Taugh/sql-queries-reviews/blob/main/inventory/purchase_orders/allen_bradley_po_summary_refactored.sql
                   Branch: main
                   Last Reviewed: 2025-09-05 by Troy Brannon

Change Log       : 
                   - 2025-09-05: Refactored for modularity, parameterization, AND maintainability.
******************************************************************************************/

-- Declare parameters
DECLARE @StartOfYear DATE = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
DECLARE @siteid VARCHAR(8) = 'FWN';
DECLARE @storeloc VARCHAR(8) = 'FWNCS';

-- Manufacturer aliases
DECLARE @manufacturer TABLE (name VARCHAR(50));
INSERT INTO @manufacturer(name)
VALUES ('1052'), ('1942'), ('1949'), ('A&B'), ('A-B'), ('ALLEN-BRADLEY'), ('ALLEN-BRADLEY FW');

-- CTE to get latest revision per PO
WITH LatestPO AS (
    SELECT ponum, MAX(revisionnum) AS revisionnum
    FROM dbo.po
    GROUP BY ponum
)

SELECT DISTINCT 
    p.ponum,
    p.revisionnum,
    l.polinenum,
    l.itemnum,
    l.description,
    p.orderdate,
    l.orderqty,
    i.glaccount,
    l.manufacturer,
    p.receipts
FROM dbo.po AS p
INNER JOIN LatestPO AS lp
    ON p.ponum = lp.ponum AND p.revisionnum = lp.revisionnum
INNER JOIN dbo.poline AS l
    ON p.ponum = l.ponum AND p.revisionnum = l.revisionnum
INNER JOIN dbo.inventory AS i
    ON l.itemnum = i.itemnum AND l.storeloc = i.location
WHERE 
    p.siteid = @siteid
    AND l.storeloc = @storeloc
    AND p.orderdate >= @StartOfYear
    AND (
        l.manufacturer IN (SELECT name 
                           FROM @manufacturer)
         OR l.description LIKE '%ALLEN BRADLEY%'
        )
ORDER BY p.ponum;
