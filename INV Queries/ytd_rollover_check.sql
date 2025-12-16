
-- Identify inventory items WITH non-zero YTD usage
-- but last issued before the start of the current year
-- These items may NOT have rolled over correctly ON January 1st

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
