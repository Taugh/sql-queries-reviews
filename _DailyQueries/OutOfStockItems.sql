USE max76PRD
GO

/***************************************************************************************************
Query Name: WO_Stockout_And_Unclaimed_Orders.sql
Location / File Path: sql/inventory/WO_Stockout_And_Unclaimed_Orders.sql

Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0

Purpose:
  Identify inventory issues at location 'FWNCS' related to stockouts and unclaimed reservations:
  - First query flags items where reserved quantity exceeds current balance (stockout).
  - Second query lists reservations not picked up within 48 hours despite sufficient stock.

Row Grain:
  - First query: One row per itemnum with stockout condition.
  - Second query: One row per reservation (INVRESERVE).

Assumptions:
  - INVRESERVE and INVBALANCES are joined on itemnum, location, siteid, and itemsetid.
  - ITEM provides descriptions for itemnum.
  - Stockout is defined as reserved quantity > current balance.
  - Unclaimed orders are those with requireddate older than 48 hours and sufficient stock.

Parameters:
  @SiteID        : Target site (default 'FWN')
  @Location      : Inventory location (default 'FWNCS')
  @CurrentMonth  : Computed from GETDATE()
  @StockoutAge   : 24 hours (for stockout urgency)
  @UnclaimedAge  : 48 hours (for pickup delay)

Filters:
  - Site = 'FWN' and Location = 'FWNCS'
  - Stockout: ReservedQty > CurBal and RequiredDate < NOW - 24h and within current month
  - Unclaimed: ReservedQty <= CurBal and RequiredDate < NOW - 48h

Security:
  - Read-only; no sensitive columns.

Version Control:
  - Store under /sql/inventory with a paired doc under /docs/inventory.

Change Log:
  2025-09-05  TB/M365  Initial review and header standardization: clarified logic, added filters,
                       ensured join safety, aligned with reporting standards.
***************************************************************************************************/


SELECT DISTINCT r.itemnum
FROM invreserve AS r
    JOIN invbalances AS b
ON r.itemnum = b.itemnum 
    AND r.location = b.location 
    AND r.siteid = b.siteid 
    AND r.itemsetid = b.itemsetid 
WHERE r.siteid = 'FWN' 
    AND r.location = 'FWNCS' 

    -- Check for stockout: reserved quantity exceeds current balance
    AND r.reservedqty > b.curbal 

    -- Required date is more than 24 hours ago
    AND DATEADD(HOUR, 24, r.requireddate) < CURRENT_TIMESTAMP 

    -- Required date is within the current month
    AND r.requireddate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)

ORDER BY r.itemnum;

--Orders not picked up within 48 hours
SELECT r.requestnum
	,r.itemnum
	,i.description
	,r.reservedqty
	,b.curbal
	,r.wonum
	,r.mrnum
	,r.requestedby
	,r.requireddate
FROM invreserve AS r
	JOIN invbalances AS b
		ON (r.itemnum = b.itemnum and r.location = b.location and r.siteid = b.siteid and r.itemsetid = b.itemsetid)
	JOIN item AS i
		ON (r.itemnum = i.itemnum and r.itemsetid = i.itemsetid)
WHERE r.siteid = 'FWN' and r.location = 'FWNCS' and r.reservedqty <= b.curbal 
	and DATEADD(HOUR,48,r.requireddate) < CURRENT_TIMESTAMP
ORDER BY itemnum;