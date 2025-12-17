USE max76PRD

/*
  =============================================
  Query: ABC-Balanced Cycle Count List
  Purpose: Generate a cycle count list balanced across ABC types WITH future count windows
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare date thresholds for each ABC type
DECLARE @AWindow DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 2, 0);
DECLARE @BWindow DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 3, 0);
DECLARE @CWindow DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0);

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
        '' AS 'New Count'  --Blank field for data entry
    FROM dbo.inventory AS inv
    INNER JOIN dbo.item AS it
        ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
    INNER JOIN dbo.invbalances AS ib
        ON inv.itemnum = ib.itemnum AND inv.location = ib.location
    WHERE it.itemsetid = 'IUS'
      AND inv.siteid = 'FWN'
      AND inv.location = 'FWNCS'
      AND inv.status NOT IN ('OBSOLETE')
      AND inv.abctype = 'A'
      AND ib.physcntdate < DATEADD(DAY, -inv.ccf, @AWindow) 
    ORDER BY [Item #]
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
    FROM dbo.inventory AS inv
    INNER JOIN dbo.item AS it
        ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
    INNER JOIN dbo.invbalances AS ib
        ON inv.itemnum = ib.itemnum AND inv.location = ib.location
    WHERE it.itemsetid = 'IUS'
      AND inv.siteid = 'FWN'
      AND inv.location = 'FWNCS'
      AND inv.status NOT IN ('OBSOLETE')
      AND inv.abctype = 'B'
      AND ib.physcntdate < DATEADD(DAY, -inv.ccf, @BWindow)
    ORDER BY [Item #]
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
    FROM dbo.inventory AS inv
    INNER JOIN dbo.item AS it
        ON inv.itemnum = it.itemnum AND inv.itemsetid = it.itemsetid
    INNER JOIN dbo.invbalances AS ib
        ON inv.itemnum = ib.itemnum AND inv.location = ib.location
    WHERE it.itemsetid = 'IUS'
      AND inv.siteid = 'FWN'
      AND inv.location = 'FWNCS'
      AND inv.status NOT IN ('OBSOLETE')
      AND inv.abctype = 'C'
      AND ib.physcntdate < DATEADD(DAY, -inv.ccf, @CWindow)
    ORDER BY [Item #]
)

-- Combine all ABC types
SELECT inv.itemnum AS 'Item #',
        ib.binnum AS 'Default Bin',
        inv.binnum AS 'Bin',
        it.description AS 'Item Description',
        inv.abctype AS 'ABC Type',
        inv.ccf AS 'Count Frequency',
        CONVERT(varchar(10), ib.physcntdate, 111) AS 'Last Count Date',
        ib.curbal AS 'Current Balance',
        '' AS 'New Count'  --Blank field for data entry 
FROM a_type
UNION ALL
SELECT inv.itemnum AS 'Item #',
        ib.binnum AS 'Default Bin',
        inv.binnum AS 'Bin',
        it.description AS 'Item Description',
        inv.abctype AS 'ABC Type',
        inv.ccf AS 'Count Frequency',
        ib.physcntdate AS 'Last Count Date',
        ib.curbal AS 'Current Balance',
        '' AS 'New Count'  --Blank field for data entry
FROM b_type
UNION ALL
SELECT inv.itemnum AS 'Item #',
        ib.binnum AS 'Default Bin',
        inv.binnum AS 'Bin',
        it.description AS 'Item Description',
        inv.abctype AS 'ABC Type',
        inv.ccf AS 'Count Frequency',
        ib.physcntdate AS 'Last Count Date',
        ib.curbal AS 'Current Balance',
        '' AS 'New Count'
FROM c_type;