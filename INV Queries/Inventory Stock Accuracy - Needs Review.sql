USE max76PRD

/*=======================================================================================
Query Name: Inventory Stock Accuracy - Needs Review

Purpose: Identify inventory items that had balance adjustments 
         (RECBALADJ) in the previous month, indicating potential accuracy issues.

Row Grain: One row per Item Number + Bin Number + Site

Assumptions:
    - Adjustments WITH transtype = 'RECBALADJ' represent stock corrections.
    - SiteID filter is fixed to 'FWN'.
    - Current balance is sourced FROM invbalances.curbal.

Parameters:
    - SiteID = 'FWN'
    - Date range = Previous month FROM current date

Filters:
    - Only items WITH adjustment_count > 0 are returned.

Security:
    - Query reads FROM Maximo transactional tables (INVTRANS, INVBALANCES).
    - No updates OR deletes performed.

Version Control:
    - Version: 1.0
    - Author: Troy Brannon
    - Date: 2025-12-02

Change Log:
    - 1.0 Initial version created for Inventory Health reporting.
	 - Store under: 
=======================================================================================*/

DECLARE @site1 VARCHAR(3) = 'FWN';
DECLARE @site2 VARCHAR(5) = 'ASPEX';
DECLARE @active_site VARCHAR(5) = @site1;  -- change site here

;WITH InventoryAdjustments AS (
    SELECT
        inv.itemnum,
        inv.siteid,
        COUNT(CASE WHEN transtype = 'RECBALADJ' THEN 1 END) AS adjustment_count,
        SUM(CASE WHEN transtype = 'RECBALADJ' THEN quantity ELSE 0 END) AS total_adjusted_qty
    FROM dbo.invtrans inv
    WHERE transtype = 'RECBALADJ'
      AND inv.siteid = @active_site
      AND transdate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CAST(GETDATE() AS DATE)) - 1, 0)  -- Previous month
    GROUP BY inv.itemnum, inv.siteid
),
CurrentStock AS (
    SELECT
        itemnum,
        binnum,
        siteid,
        curbal AS current_balance
    FROM dbo.invbalances
)
SELECT
    cs.itemnum,
    cs.binnum,
    cs.siteid,
    cs.current_balance,
    ISNULL(ia.adjustment_count, 0) AS adjustment_count,
    ISNULL(ia.total_adjusted_qty, 0) AS total_adjusted_qty
FROM CurrentStock AS cs
LEFT JOIN InventoryAdjustments AS ia
    ON cs.itemnum = ia.itemnum AND cs.siteid = ia.siteid
WHERE ISNULL(ia.adjustment_count, 0) > 0
ORDER BY ia.adjustment_count DESC;

