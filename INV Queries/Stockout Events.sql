USE max76PRD

/*=================================================================================================
Query Name: Inventory Stockout Events WITH PO Details AND Bin Breakdown

Purpose:
    Identify inventory items that had a zero balance at any point during
    the previous month AND provide:
        - Current balance (all bins summed)
        - Bin-level breakdown
        - Minimum stock level
        - Item description
        - ON-order status
        - Total quantity ON order
        - Earliest estimated delivery date
        - Earliest PO number

Row Grain:
    One row per Item Number + Site (aggregated across bins)

Assumptions:
    - Zero balance indicates a stockout event.
    - SiteID filter is fixed to 'FWN'.
    - Estimated delivery date = PO Order Date + INVENTORY.DELIVERYTIME (days).
    - Only active inventory items are considered.
    - Only open POs WITH remaining quantity are included.

Parameters:
    - SiteID = @active_site which can be changed between @site1 (FWN) OR @site2 (ASPEX)
    - Date range = Previous month FROM current date
    - PO statuses considered: APPR, INPRG, WAPPR, ORDERED
	+

Filters:
    - Items WITH total current balance = 0 (true stockout)
    - Exclude closed OR canceled POs
    - Exclude fully received PO lines

Security:
    - Read-only query accessing INVBALANCES, INVTRANS, INVENTORY, POLINE, PO, AND ITEM tables.

Version Control:
    - Version: 2.1
    - Author: Troy Brannon
    - Date: 2025-12-02

Change Log:
    - 1.0 Initial version created for Inventory Health reporting.
    - 1.1 Added PO details (quantity, estimated delivery, PO number).
    - 1.2 Added bin-level breakdown using STRING_AGG.
    - 2.0 Added filters for open POs AND remaining quantity.
    - 2.1 Added item description FROM ITEM table.
=================================================================================================*/

DECLARE @site1 VARCHAR(3) = 'FWN';
DECLARE @site2 VARCHAR(5) = 'ASPEX';
DECLARE @active_site VARCHAR(5) = @site1;  -- change site here

;WITH PO_Filtered AS (
    SELECT
        poline.itemnum,
        poline.siteid,
        poline.ponum,
        poline.orderqty,
        poline.receivedqty,
        po.orderdate,
        DATEADD(DAY, ISNULL(inv.deliverytime, 0), po.orderdate) AS estimated_delivery,
        ROW_NUMBER() OVER (PARTITION BY poline.itemnum, poline.siteid ORDER BY po.orderdate ASC) AS rn
    FROM dbo.poline
        INNER JOIN dbo.po 
    ON poline.ponum = po.ponum AND poline.siteid = po.siteid
        INNER JOIN dbo.inventory AS inv 
    ON poline.itemnum = inv.itemnum AND poline.siteid = inv.siteid
    WHERE po.status IN ('APPR', 'INPRG', 'WAPPR', 'ORDERED')
      AND (poline.orderqty - ISNULL(poline.receivedqty, 0)) > 0
      AND DATEADD(DAY, ISNULL(inv.deliverytime, 0), po.orderdate) >= DATEADD(DAY, -180, GETDATE())
),
PO_Aggregated AS (
    SELECT
        itemnum,
        siteid,
        SUM(orderqty - ISNULL(receivedqty, 0)) AS total_quantity_on_order,
        MIN(estimated_delivery) AS earliest_estimated_delivery,
        MAX(CASE WHEN rn = 1 THEN ponum END) AS earliest_po_num
    FROM PO_Filtered
    GROUP BY itemnum, siteid
),
ZeroBalanceItems AS (
    SELECT DISTINCT
        trans.itemnum,
        trans.siteid,
        MIN(trans.transdate) AS first_zero_balance_date
    FROM dbo.invtrans trans
        INNER JOIN dbo.invbalances bal
    ON trans.itemnum = bal.itemnum AND trans.siteid = bal.siteid 
        AND trans.binnum = bal.binnum
	WHERE trans.siteid = @active_site
      AND trans.transdate >= DATEADD(MONTH, -1, CAST(GETDATE() AS DATE))
      AND bal.curbal = 0
    GROUP BY trans.itemnum, trans.siteid
),
CurrentInventory AS (
    SELECT
        itemnum,
        siteid,
        SUM(curbal) AS total_current_balance,
        STRING_AGG(binnum + ':' + CAST(curbal AS VARCHAR), ', ') AS bin_details
    FROM dbo.invbalances
    WHERE siteid = @active_site
    GROUP BY itemnum, siteid
)
SELECT
    zb.itemnum,
    itm.description AS item_description,
    zb.siteid,
    ci.total_current_balance AS current_balance,
    ci.bin_details AS bin_breakdown,
    zb.first_zero_balance_date AS date_of_first_zero_event,
    ivt.minlevel,
    CASE 
        WHEN poagg.itemnum IS NOT NULL THEN 'ON Order'
        ELSE 'NOT ON Order'
    END AS on_order_status,
    ISNULL(poagg.total_quantity_on_order, 0) AS quantity_on_order,
    poagg.earliest_estimated_delivery AS estimated_delivery_date,
    poagg.earliest_po_num AS po_number
FROM ZeroBalanceItems AS zb
INNER JOIN CurrentInventory ci
    ON zb.itemnum = ci.itemnum AND zb.siteid = ci.siteid
INNER JOIN dbo.inventory AS ivt
    ON zb.itemnum = ivt.itemnum AND zb.siteid = ivt.siteid
INNER JOIN dbo.item AS itm
    ON zb.itemnum = itm.itemnum
LEFT JOIN PO_Aggregated AS poagg
    ON zb.itemnum = poagg.itemnum AND zb.siteid = poagg.siteid
WHERE ivt.status = 'ACTIVE'
  AND ci.total_current_balance = 0  -- TRUE stockout: ALL bins are zero
ORDER BY zb.first_zero_balance_date ASC;
