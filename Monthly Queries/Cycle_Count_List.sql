USE max76PRD

/*
  =============================================
  Query: Monthly Cycle Count List
  Purpose: Identify inventory items due for cycle count based on last count date and count frequency
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare reusable date variable for next month start
DECLARE @NextMonthStart DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0);

-- Monthly Cycle Count
SELECT TOP 3200
    inv.itemnum AS 'Item #',
    ib.binnum AS 'Default Bin',
    inv.binnum AS 'Bin',
    it.description AS 'Item Description',
    inv.abctype AS 'ABC Type',
    inv.ccf AS 'Count Frequency',
    CONVERT(varchar(10), ib.physcntdate, 111) AS 'Last Count Date',
    -- Uncomment below if you want to show next count date
    -- CONVERT(varchar(10), DATEADD(DAY, inv.ccf, ib.physcntdate), 111) AS 'Next Count Date',
    ib.curbal AS 'Current Balance',
    '' AS 'New Count'
FROM inventory AS inv
INNER JOIN item AS it
    ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
INNER JOIN invbalances AS ib
    ON inv.itemnum = ib.itemnum AND inv.location = ib.location
WHERE it.itemsetid = 'IUS'
  AND inv.siteid = 'FWN'
  AND inv.location = 'FWNCS'
  AND inv.status NOT IN ('OBSOLETE')
  AND inv.abctype IS NOT NULL
  AND DATEADD(DAY, inv.ccf, ib.physcntdate) < @NextMonthStart
ORDER BY inv.abctype, ib.physcntdate, inv.itemnum, ib.binnum, inv.binnum;