USE max76PRD

/*
  =============================================
  Query: Returns Transactions
  Purpose: Identify all return transactions FROM the previous month
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare reusable date variables
DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @EndDate   DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);

-- Returns Only
SELECT 
    m.itemnum AS 'Item',
    m.description AS 'Description',
    m.mrnum AS 'MR',
    ISNULL(m.refwo, '') AS 'Work Order',
    m.enterby AS 'Entered By',
    m.actualdate AS 'Return Date',
    m.issuetype
FROM dbo.a_matusetrans AS m
WHERE m.siteid = 'FWN'
  AND m.eaudittimestamp >= @StartDate
  AND m.eaudittimestamp < @EndDate
  AND m.issuetype = 'RETURN'
ORDER BY m.mrnum, m.mrlinenum, m.actualdate;