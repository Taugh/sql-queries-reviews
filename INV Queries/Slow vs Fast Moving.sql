USE max76PRD

/*===============================================================================================================
Query Name: Slow vs Fast Moving Items (Dynamic, No Medium)

File Path: C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\INV Queries\Slow vs Fast Moving.sql

Purpose: Return only Fast-Moving AND Slow-Moving items based ON percentile thresholds. 
		 Ranking is determined by either the total quantity issued OR the number of transactions.

Row Grain: One row per item per site (last 12 whole months).

Assumptions:
    - Movement measured by sum of `quantity` AND count of usage transactions in matusetrans.
    - Fast-Moving: qty_rank >= 0.971 OR txn_rank >= 0.97
    - Slow-Moving: qty_rank <= 0.20 AND txn_rank <= 0.20

Parameters:
    - @start_date DATE = first day of the month 12 months ago
    - @end_date   DATE = first day of the current month

Filters:
    - transdate >= @start_date AND transdate < DATEADD(DAY, 1, @end_date)

Security:
    - Read-only access to `matusetrans`.

Version Control:
    - v2.1 | 2025-12-02 | Filtered out Medium, retained dynamic thresholds.

Change Log:
    - 2025-12-02 | Added WHERE clause to include only Fast & Slow categories.
=================================================================================================================*/

DECLARE @start_date DATE = DATEADD(MONTH, DATEDIFF(MONTH, 0, CAST(GETDATE() AS DATE)) - 12, 0);
DECLARE @end_date   DATE = DATEADD(MONTH, DATEDIFF(MONTH, 0, CAST(GETDATE() AS DATE)) + 0, 0);
DECLARE @upper_cutoff DECIMAL(5,4) = 0.968;  -- Fast threshold
DECLARE @lower_cutoff DECIMAL(5,4) = 0.01;   -- Slow threshold
DECLARE @site1 VARCHAR(3) = 'FWN';
DECLARE @site2 VARCHAR(5) = 'ASPEX';
DECLARE @active_site VARCHAR(5) = @site1;    -- change site here

;WITH ItemUsage AS (
    SELECT
        mt.itemnum,
		mt.description,
        mt.siteid,
        SUM(COALESCE(ABS(mt.quantity), 0)) AS total_qty,
        COUNT(mt.matusetransid) AS txn_count
    FROM dbo.matusetrans AS mt
    WHERE
        mt.siteid = @active_site
        AND mt.transdate >= @start_date
        AND mt.transdate < DATEADD(DAY, 1, @end_date)
        AND mt.itemnum IS NOT NULL
        AND mt.siteid IS NOT NULL
        AND mt.issuetype = 'ISSUE'
    GROUP BY
        mt.itemnum, mt.description, mt.siteid
    HAVING SUM(COALESCE(ABS(mt.quantity), 0)) > 0  -- Exclude items WITH zero usage
),
Ranked AS (
    SELECT
        itemnum,
		description,
        siteid,
        total_qty AS total_qty_issued,
        txn_count AS total_times_issued,
        PERCENT_RANK() OVER (ORDER BY total_qty ASC) AS qty_rank,
        PERCENT_RANK() OVER (ORDER BY txn_count ASC) AS txn_rank
    FROM ItemUsage
)
SELECT
    r.itemnum,
	r.description,
    r.siteid,
    total_qty_issued,
    total_times_issued,
    i.minlevel,
	i.deliverytime AS 'lead time',
    CASE 
        WHEN i.minlevel > total_qty_issued THEN 'Over-Stocked'  -- Minlevel exceeds actual usage
        WHEN qty_rank >= @upper_cutoff OR txn_rank >= @upper_cutoff THEN 'Fast-Moving'
        WHEN qty_rank <= @lower_cutoff OR txn_rank <= @lower_cutoff THEN 'Slow-Moving'
        ELSE 'Medium-Moving'
    END AS movement_category,
    CASE 
        WHEN i.minlevel > 0 THEN CAST(total_qty_issued AS DECIMAL(10,2)) / i.minlevel 
        ELSE NULL 
    END AS usage_to_minlevel_ratio  -- Shows how many times minlevel was used in the period
FROM Ranked AS r
INNER JOIN dbo.inventory AS i
    ON r.itemnum = i.itemnum AND r.siteid = i.siteid
WHERE
    -- Include Fast-Moving, Slow-Moving, OR Over-Stocked
    (qty_rank >= @upper_cutoff OR txn_rank >= @upper_cutoff)
    OR (qty_rank <= @lower_cutoff OR txn_rank <= @lower_cutoff)
    OR (i.minlevel > total_qty_issued)  -- Include over-stocked items
ORDER BY movement_category, total_qty_issued DESC;