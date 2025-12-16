USE max76PRD


/******************************************************************************************
Query Name       : last_count_by_item.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\INV Queries.sql
     Repository  : https://github.com/Taugh/sql-queries-reviews/blob/main/INV%20Queries/last_count_by_item.sql
Author           : Troy Brannon
Date Created     : 2025-09-05
Last Modified    : 2025-09-05

Purpose          : Retrieve last physical count date AND item details for selected items.
                   Filters by site, location, item status, AND itemset. Formats count date.

Row Grain        : One row per itemnum per location.

Assumptions      : 
                   - Only items FROM itemset 'IUS' are considered.
                   - Site AND location are hardcoded AS 'FWN' AND 'FWNCS'.
                   - Status 'OBSOLETE' items are excluded.
                   - Last count date is sourced FROM invbalances.physcntdate.
                   - Item numbers must be manually specified in the IN clause.

Parameters       : 
                   - None currently parameterized; itemnum list must be manually updated.

Filters          : 
                   - itemsetid = 'IUS'
                   - siteid = 'FWN'
                   - location = 'FWNCS'
                   - status NOT IN ('OBSOLETE')
                   - itemnum IN ('') — placeholder to be replaced WITH actual VALUES.

Security         : No sensitive data exposed. Ensure access to inventory, item, AND 
                   invbalances tables is properly controlled.

Version Control  : Stored in GitHub repository 'sql-queries-reviews'
                   Branch: main
                   Last Reviewed: 2025-09-05 by Troy Brannon

Change Log       : 
                   - 2025-09-05: Initial header added AND query reviewed for clarity.
******************************************************************************************/


SELECT
    i.itemnum AS [Item #],
    i.binnum AS [Default Bin],
    t.description AS [Item Description],
    i.abctype AS [ABC Type],
    i.ccf AS [Count Frequency],
    CONVERT(varchar(10), b.physcntdate, 111) AS [Last Count Date]
FROM dbo.inventory AS i
INNER JOIN dbo.item AS t
    ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
INNER JOIN dbo.invbalances AS b
    ON i.itemnum = b.itemnum AND i.location = b.location
WHERE t.itemsetid = 'IUS'
  AND i.siteid = 'FWN'
  AND i.location = 'FWNCS'
  AND i.status NOT IN ('OBSOLETE')
  AND i.itemnum IN ('')  -- TODO: Replace WITH actual item numbers
