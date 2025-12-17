USE max76PRD

/*
  =============================================
  Query: Issued Items Transactions
  Purpose: Identify all issued items FROM the previous month
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare reusable date variables
DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @EndDate   DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);

-- Issue Items Only
SELECT 
    ISNULL(m.mrnum, 'No MR') AS 'MR',
    ISNULL(m.mrlinenum, '') AS 'MR Line',
    w.assetnum AS 'Asset',
    a.description AS 'Asset Description',
    m.itemnum AS 'Item',
    m.description AS 'Description',
    r.qty AS 'MR Requested QTY',
    p.itemqty AS 'WO Planned QTY',
    m.quantity AS 'Issued Quantity',
    m.binnum AS 'FROM Bin',
    ISNULL(m.refwo, '') AS 'Work Order',
    w.worktype AS 'Work Type',
    m.issueto AS 'Issued To',
    m.enterby AS 'Issued By',
    m.actualdate AS 'Issue Date',
    ISNULL(m.memo, '') AS 'Memo',
    m.issuetype
FROM dbo.a_matusetrans AS m
LEFT JOIN dbo.workorder AS w
    ON m.refwo = w.wonum AND m.siteid = w.siteid
LEFT JOIN dbo.mrline AS r
    ON m.mrnum = r.mrnum AND m.mrlinenum = r.mrlinenum AND m.siteid = r.siteid
LEFT JOIN dbo.wpmaterial AS p
    ON m.refwo = p.wonum AND m.siteid = p.siteid AND m.itemnum = p.itemnum
LEFT JOIN dbo.asset AS a
    ON w.assetnum = a.assetnum AND w.siteid = a.siteid
WHERE m.siteid = 'FWN'
  AND m.eaudittimestamp >= @StartDate AND m.eaudittimestamp < @EndDate
  AND m.issuetype = 'ISSUE'
ORDER BY m.mrnum, m.mrlinenum, m.actualdate;