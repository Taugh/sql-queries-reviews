Use max76PRD

/*
  =============================================
  Report: Central Stores Metrics – Purchase Orders
  Purpose: Monthly metrics for PO activity, aging, AND cost
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare reusable date variables
DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @EndDate   DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);
DECLARE @SixtyDaysAgo DATETIME2 = DATEADD(DAY, -60, GETDATE());
DECLARE @NextMonthStart DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0);

-- POs Issued Last Month
SELECT COUNT(ponum) AS 'POs Issued'
FROM dbo.po
WHERE historyflag = 0 AND siteid = 'FWN'
  AND orderdate >= @StartDate AND orderdate < @EndDate;

-- Total Cost of POs Last Month
SELECT FORMAT(SUM(totalcost), 'N', 'en-us') AS 'Total Cost'
FROM dbo.po
WHERE historyflag = 0 AND siteid = 'FWN'
  AND orderdate >= @StartDate AND orderdate < @EndDate;

-- POs Open Greater Than 60 Days
SELECT COUNT(ponum) AS 'POs Greater 60'
FROM dbo.po
WHERE historyflag = 0 AND receipts != 'COMPLETE' AND siteid = 'FWN'
  AND orderdate <= @SixtyDaysAgo;

-- POs Open Less Than 60 Days
SELECT COUNT(ponum) AS 'POs Less 60'
FROM dbo.po
WHERE historyflag = 0 AND receipts != 'COMPLETE' AND siteid = 'FWN'
  AND orderdate >= @SixtyDaysAgo AND orderdate < @NextMonthStart;

-- POs WITH Required Date Older Than 60 Days
SELECT COUNT(ponum) AS 'POs +60 Require Date'
FROM dbo.po
WHERE historyflag = 0 AND receipts != 'COMPLETE' AND siteid = 'FWN'
  AND requireddate IS NOT NULL
  AND (
        requireddate <= @SixtyDaysAgo
        OR orderdate <= @SixtyDaysAgo
      );