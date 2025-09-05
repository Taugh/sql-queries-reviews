
-- Identify inventory items with non-zero YTD usage
-- but last issued before the start of the current year
-- These items may not have rolled over correctly on January 1st

SELECT
    itemnum,
    status,
    location,
    siteid,
    lastissuedate,
    issueytd
FROM dbo.inventory
WHERE siteid = 'FWN'
  AND location = 'FWNCS'
  AND status != 'OBSOLETE'
  AND issueytd > 0
  AND lastissuedate < DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0);
