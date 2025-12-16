USE max76PRD
GO

/***************************************************************************************************
Query Name: WO_Stockout_And_Unclaimed_Orders.sql
Location / File Path: sql/inventory/WO_Stockout_And_Unclaimed_Orders.sql

Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0

Purpose:
  Identify inventory issues at location 'FWNCS' related to stockouts AND unclaimed reservations:
  - First query flags items WHERE reserved quantity exceeds current balance (stockout).
  - Second query lists reservations NOT picked up within 48 hours despite sufficient stock.

Row Grain:
  - First query: One row per itemnum WITH stockout condition.
  - Second query: One row per reservation (INVRESERVE).

Assumptions:
  - INVRESERVE AND INVBALANCES are joined ON itemnum, location, siteid, AND itemsetid.
  - ITEM provides descriptions for itemnum.
  - Stockout is defined AS reserved quantity > current balance.
  - Unclaimed orders are those WITH requireddate older than 48 hours AND sufficient stock.

Parameters:
  @SiteID        : Target site (default 'FWN')
  @Location      : Inventory location (default 'FWNCS')
  @CurrentMonth  : Computed FROM GETDATE()
  @StockoutAge   : 24 hours (for stockout urgency)
  @UnclaimedAge  : 48 hours (for pickup delay)

Filters:
  - Site = 'FWN' AND Location = 'FWNCS'
  - Stockout: ReservedQty > CurBal AND RequiredDate < NOW - 24h AND within current month
  - Unclaimed: ReservedQty <= CurBal AND RequiredDate < NOW - 48h

Security:
  - Read-only; no sensitive columns.

Version Control:
  - Store under /sql/inventory WITH a paired doc under /docs/inventory.

Change Log:
  2025-09-05  TB/M365  Initial review AND header standardization: clarified logic, added filters,
                       ensured JOIN safety, aligned WITH reporting standards.
***************************************************************************************************/


SELECT DISTINCT r.itemnum
FROM dbo.invreserve AS r
    INNER JOIN dbo.invbalances AS b
ON r.itemnum = b.itemnum 
    AND r.location = b.location 
    AND r.siteid = b.siteid 
    AND r.itemsetid = b.itemsetid 
WHERE r.siteid = 'FWN' 
    AND r.location = 'FWNCS' 

    -- Check for stockout: reserved quantity exceeds current balance
    AND r.reservedqty > b.curbal 
    -- Required date is more than 24 hours ago
    AND r.requireddate < DATEADD(HOUR, -24, CURRENT_TIMESTAMP)
    -- Required date is within the current month
    AND r.requireddate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)

ORDER BY r.itemnum;

--Orders NOT picked up within 48 hours
SELECT r.requestnum
	,r.itemnum
	,i.description
	,r.reservedqty
	,b.curbal
	,r.wonum
	,r.mrnum
	,r.requestedby
	,r.requireddate
FROM dbo.invreserve AS r
	INNER JOIN dbo.invbalances AS b
ON (r.itemnum = b.itemnum AND r.location = b.location AND r.siteid = b.siteid AND r.itemsetid = b.itemsetid)
	INNER JOIN dbo.item AS i
ON (r.itemnum = i.itemnum AND r.itemsetid = i.itemsetid)
WHERE r.siteid = 'FWN' AND r.location = 'FWNCS' AND r.reservedqty <= b.curbal 
	AND r.requireddate < DATEADD(HOUR, -48, CURRENT_TIMESTAMP)
ORDER BY itemnum;