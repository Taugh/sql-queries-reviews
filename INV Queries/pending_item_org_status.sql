
-- Identify inventory items that are not obsolete
-- and have a pending status in itemorginfo, which excludes them from reorder reports
-- Join is based on org instead of siteid since itemorginfo status is at the org level

SELECT
    i.itemnum AS [Item #],
    i.binnum AS [Default Bin],
    i.status AS [Inventory Status],
    io.status AS [Org Status]
FROM dbo.inventory AS i
INNER JOIN dbo.itemorginfo AS io
    ON i.itemnum = io.itemnum AND i.itemsetid = io.itemsetid AND i.orgid = io.orgid
WHERE i.siteid = 'FWN'
  AND i.location = 'FWNCS'
  AND i.status NOT IN ('OBSOLETE')
  AND io.status = 'PENDING';
