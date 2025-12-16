USE max76PRD

/*
  =============================================
  Report: Central Stores Metrics � Material Requisitions
  Purpose: Monthly metrics for MR activity AND fulfillment performance
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare reusable date variables
DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @EndDate   DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);

-- Count of MRs Created Last Month
SELECT COUNT(mrnum) AS 'Total Requisition'
FROM dbo.mr
WHERE siteid = 'FWN'
  AND status NOT IN ('CAN', 'DRAFT', 'WAPPR')
  AND enterdate >= @StartDate AND enterdate < @EndDate;

-- List of MRs Created Last Month
SELECT 
    mrnum,
    description,
    enterdate,
    status,
    requestedby,
    requestedfor,
    totalcost
FROM dbo.mr
WHERE siteid = 'FWN'
  AND status NOT IN ('CAN', 'DRAFT')
  AND enterdate >= @StartDate AND enterdate < @EndDate
ORDER BY enterby ASC;

-- Count of Item Requests Filled Late
SELECT COUNT(invusenum) AS 'Filled Late'
FROM dbo.invuse
WHERE status NOT IN ('CAN') AND siteid = 'FWN'
  AND EXISTS (
      SELECT 1
      FROM dbo.invuseline
      WHERE invuseline.invusenum = invuse.invusenum
        AND invuseline.siteid = invuse.siteid
        AND actualdate >= @StartDate AND actualdate < @EndDate
        AND EXISTS (
            SELECT 1
            FROM dbo.mrline
            WHERE mrline.siteid = invuseline.tositeid
              AND mrline.mrnum = invuseline.mrnum
              AND mrline.mrlinenum = invuseline.mrlinenum
              AND mrline.requireddate < invuseline.actualdate
              AND mrline.requireddate < invuse.statusdate
        )
  );