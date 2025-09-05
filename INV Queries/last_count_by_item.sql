
-- Retrieve last count date and item details for selected items
-- Filters by site, location, item status, and itemset
-- Converts last count date to yyyy/mm/dd format

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
  AND i.itemnum IN ('')  -- TODO: Replace with actual item numbers
