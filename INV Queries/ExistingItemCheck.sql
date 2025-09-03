USE max76PRD

-- Purpose: Check for existing model numbers in inventory to prevent duplicates
-- Notes:
--   - Filters out obsolete items
--   - Compares new item list against existing inventory

;WITH existing_inventory AS (
    SELECT itemnum, modelnum, binnum
    FROM inventory
    WHERE siteid = 'FWN' 
      AND itemsetid = 'IUS' 
      AND location = 'FWNCS' 
      AND status != 'OBSOLETE'
),
new_items AS (
    SELECT 'NEW123' AS modelnum
    UNION ALL SELECT 'NEW456'
    UNION ALL SELECT 'NEW789'
    -- Add more model numbers as needed
)

SELECT DISTINCT 
    ei.itemnum,
    ei.modelnum,
    ei.binnum
FROM existing_inventory AS ei
INNER JOIN new_items AS ni
    ON ei.modelnum = ni.modelnum
ORDER BY ei.modelnum;