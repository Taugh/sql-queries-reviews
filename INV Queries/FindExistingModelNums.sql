USE max76PRD

SELECT modelnum, COUNT(*) AS item_count
FROM dbo.inventory
WHERE itemsetid = 'IUS'
  AND siteid = 'FWN'
  AND location = 'FWNCS'
  AND (status IS NOT NULL AND status != 'OBSOLETE') -- Ensure NULLs don�t interfere
GROUP BY modelnum
HAVING COUNT(*) > 1
ORDER BY item_count DESC;

