USE max76PRD
GO

-- Purpose: Find duplicate model numbers WITH different item numbers in FWNCS storeroom
-- Notes:
--   - Filters out obsolete items
--   - Uses self-JOIN to compare items WITH same modelnum but different itemnum

WITH inv AS (
    SELECT itemnum, modelnum, binnum
    FROM dbo.inventory
    WHERE siteid = 'FWN' 
      AND itemsetid = 'IUS' 
      AND location = 'FWNCS' 
      AND status != 'OBSOLETE'
)

SELECT DISTINCT 
    a.itemnum,
    a.modelnum,
    a.binnum
FROM dbo.inventory AS a
INNER JOIN inv AS b
    ON a.modelnum = b.modelnum AND a.itemnum != b.itemnum
ORDER BY a.modelnum;