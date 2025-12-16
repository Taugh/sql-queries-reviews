USE max76PRD

/*=======================================================================================
Query Name: [Enter descriptive name here]
Purpose: [Explain what the query is intended to accomplish]
Row Grain: [Define the level of detail, e.g., one row per Work Order, Item, Bin, etc.]
Assumptions:
    - [List any assumptions about data, filters, OR logic]
Parameters:
    - [List dynamic parameters, e.g., SiteID, Date Range]
Filters:
    - [List applied filters, e.g., SiteID = 'FWN', Status = 'COMP']
Security:
    - [State that query is read-only AND which tables are accessed]
Version Control:
    - Version: [e.g., 1.0]
    - Author: [Your Name]
    - Date: [YYYY-MM-DD]
Change Log:
    - [Version] [Date] [Description of changes]
=======================================================================================*/

-- ===========================
-- SQL Logic Starts Below
-- ===========================

;WITH [CTE_Name] AS (
    SELECT
        -- Columns
    FROM [TableName]
    WHERE [Conditions]
    GROUP BY [Columns]
)
SELECT
    -- Final Output Columns
FROM [CTE_Name]
-- Additional Joins OR Filters
ORDER BY [Column];
