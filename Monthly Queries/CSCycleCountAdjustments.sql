USE max76PRD
GO

/*
  =============================================
  Query: Reconciled Inventory Items
  Purpose: Identify items reconciled last month with positive quantity
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  Notes: Used in Query Review project
  =============================================
*/

-- Define date range for previous month
WITH DateRange AS (
    SELECT 
        StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0),
        EndDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
)

-- Reconciled inventory query
SELECT DISTINCT
    inv.itemnum,
    MAX(inv.transdate) AS transdate,
    inv.transtype,
    inv.quantity,
    inv.curbal,
    inv.physcnt,
    inv.binnum
FROM invtrans AS inv
CROSS JOIN DateRange AS dr
WHERE inv.siteid = 'FWN'
  AND inv.transtype = 'RECBALADJ'
  AND inv.transdate >= dr.StartDate
  AND inv.transdate < dr.EndDate
  AND inv.quantity > 0
GROUP BY inv.itemnum, inv.transtype, inv.quantity, inv.curbal, inv.physcnt, inv.binnum
ORDER BY inv.itemnum;