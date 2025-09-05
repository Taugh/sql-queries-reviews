USE max76PRD

/*
  =============================================
  Query: ABC-Balanced Cycle Count List
  Purpose: Generate a cycle count list balanced across ABC types with future count windows
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare date thresholds for each ABC type
DECLARE @AWindow DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 2, 0);
DECLARE @BWindow DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 3, 0);
DECLARE @CWindow DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0);

-- ABC Cycle Count Lists
WITH a_type AS (
    SELECT TOP 85
        inv.itemnum AS 'Item #',
        ib.binnum AS 'Default Bin',
        inv.binnum AS 'Bin',
        it.description AS 'Item Description',
        inv.abctype AS 'ABC Type',
        inv.ccf AS 'Count Frequency',
        CONVERT(varchar(10), ib.physcntdate, 111) AS 'Last Count Date',
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
      AND inv.abctype = 'A'
      AND DATEADD(DAY, inv.ccf, ib.physcntdate) < @AWindow
),

b_type AS (
    SELECT TOP 820
        inv.itemnum AS 'Item #',
        ib.binnum AS 'Default Bin',
        inv.binnum AS 'Bin',
        it.description AS 'Item Description',
        inv.abctype AS 'ABC Type',
        inv.ccf AS 'Count Frequency',
        CONVERT(varchar(10), ib.physcntdate, 111) AS 'Last Count Date',
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
      AND inv.abctype = 'B'
      AND DATEADD(DAY, inv.ccf, ib.physcntdate) < @BWindow
),

c_type AS (
    SELECT DISTINCT TOP 3295
        inv.itemnum AS 'Item #',
        ib.binnum AS 'Default Bin',
        inv.binnum AS 'Bin',
        it.description AS 'Item Description',
        inv.abctype AS 'ABC Type',
        inv.ccf AS 'Count Frequency',
        CONVERT(varchar(10), ib.physcntdate, 111) AS 'Last Count Date',
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
      AND inv.abctype = 'C'
      AND DATEADD(DAY, inv.ccf, ib.physcntdate) < @CWindow
)

-- Combine all ABC types
SELECT * FROM a_type
UNION ALL
SELECT * FROM b_type
UNION ALL
SELECT * FROM c_type;