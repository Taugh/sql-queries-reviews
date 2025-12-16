USE max76PRD

/*============================================================================================
Query Name: Inventory Lead Time Analysis AND Variance Report

Purpose: Calculate actual procurement lead times FROM historical PO receipts AND compare 
         them to configured delivery times in the inventory application. Identifies items 
         WHERE configured lead times are inaccurate, missing, OR significantly different 
         FROM actual performance.

Row Grain: One row per item-site-vendor combination WITH sufficient receipt history

Assumptions:
    - Only closed POs WITH completed receipts provide reliable lead time data
    - Lead time is measured FROM PO order date to actual receipt date
    - Minimum sample size (@min_samples) ensures statistical reliability
    - Items at 'FWNCS' location only
    - Only active inventory items are included

Parameters:
    - @months_lookback: Number of months of historical data to analyze (default: 24)
    - @min_samples: Minimum number of receipts required for inclusion (default: 11)
    - @site: Site ID to filter results (default: 'FWN')

Filters:
    - PO Status = 'CLOSE' (only completed purchase orders)
    - Receipt Issue Type = 'RECEIPT' (excludes returns AND adjustments)
    - Receipt Date >= Last 24 months (configurable)
    - Inventory Status = 'ACTIVE'
    - Inventory Location = 'FWNCS'
    - Receipt Count >= 11 (configurable minimum sample size)

Security:
    - Read-only query
    - Tables accessed: poline, po, matrectrans, inventory

Version Control:
    - Version: 1.0
    - Author: Troy Brannon
    - Date: 2025-12-03

Change Log:
    - 1.0 2025-12-08 Initial version - Lead time variance analysis WITH statistical metrics
==============================================================================================*/


DECLARE @months_lookback INT = 24;  -- How many months of history to analyze
DECLARE @min_samples INT = 11;       -- Minimum receipts needed for reliable average
DECLARE @site VARCHAR(10) = 'FWN';  -- Change AS needed

-- Define site AND location filter
DECLARE @siteLocation TABLE (siteid VARCHAR(8), location VARCHAR(8));
INSERT INTO @siteLocation(siteid, location) VALUES 
    --('ASPEX', 'ASPCS')
    ('FWN', 'FWNCS')
    -- Add more pairs AS needed
    -- ('SITE3', 'LOC3')

;WITH ActualLeadTime AS (
    SELECT 
        poline.itemnum,
        poline.siteid,
        po.vendor,
        AVG(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS avg_lead_time_days,
        MIN(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS min_lead_time_days,
        MAX(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS max_lead_time_days,
        STDEV(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS lead_time_std_dev,
        COUNT(*) AS receipt_count,
        MAX(mr.actualdate) AS last_receipt_date
    FROM dbo.poline
    INNER JOIN dbo.po 
        ON poline.ponum = po.ponum AND poline.siteid = po.siteid
    INNER JOIN dbo.matrectrans mr 
        ON poline.ponum = mr.ponum AND poline.polinenum = mr.polinenum
            AND poline.itemnum = mr.itemnum AND poline.siteid = mr.siteid
    WHERE po.status = 'CLOSE'
      AND mr.issuetype = 'RECEIPT'
      AND mr.actualdate >= DATEADD(MONTH, -@months_lookback, GETDATE())
      AND poline.siteid = @site
    GROUP BY 
      poline.itemnum, 
      poline.siteid, 
      po.vendor
    HAVING COUNT(*) >= @min_samples  -- Only include items WITH sufficient data
)
SELECT 
    alt.itemnum,
    alt.siteid,
    alt.vendor,
    inv.deliverytime AS configured_lead_time,
    alt.avg_lead_time_days AS calculated_avg_lead_time,
    alt.min_lead_time_days AS calculated_min_lead_time,
    alt.max_lead_time_days AS calculated_max_lead_time,
    ROUND(alt.lead_time_std_dev, 2) AS lead_time_std_deviation,
    alt.receipt_count AS sample_size,
    alt.last_receipt_date,

    -- Variance analysis
    CASE 
        WHEN inv.deliverytime = 0 OR inv.deliverytime IS NULL THEN 'NOT CONFIGURED'
        WHEN ABS(inv.deliverytime - alt.avg_lead_time_days) <= 5 THEN 'ACCURATE'
        WHEN inv.deliverytime < alt.avg_lead_time_days THEN 'UNDERESTIMATED'
        WHEN inv.deliverytime > alt.avg_lead_time_days THEN 'OVERESTIMATED'
    END AS variance_status,
    CASE 
        WHEN inv.deliverytime > 0 THEN alt.avg_lead_time_days - inv.deliverytime
        ELSE NULL
    END AS days_difference,
    CASE 
        WHEN inv.deliverytime > 0 THEN 
            ROUND(((alt.avg_lead_time_days - inv.deliverytime) * 100.0 / inv.deliverytime), 2)
        ELSE NULL
    END AS percent_difference
FROM ActualLeadTime alt
INNER JOIN dbo.inventory inv 
    ON alt.itemnum = inv.itemnum 
    AND alt.siteid = inv.siteid
WHERE inv.status = 'ACTIVE'
    AND inv.location = 'FWNCS'
ORDER BY 
    CASE 
        WHEN inv.deliverytime = 0 OR inv.deliverytime IS NULL THEN 1
        WHEN ABS(inv.deliverytime - alt.avg_lead_time_days) > 10 THEN 2
        ELSE 3
    END,
    ABS(inv.deliverytime - alt.avg_lead_time_days) DESC;