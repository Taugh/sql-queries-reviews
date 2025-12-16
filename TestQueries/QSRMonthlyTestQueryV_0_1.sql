USE max76PRD

/*
Query Name: WO_Completion_Status_Tracking.sql
Location / File Path: C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\QSRMonthlyTestQuery.sql

Author: Troy Brannon
  Date: 2025-09-30
  Version: 1.0

Purpose:
  Track work orders within a specified date range AND identify their completion status:
  - Find all work orders WITH target completion dates between specified range
  - Show WHEN work orders reached completion status ('COMP', 'CORRECTED', 'CORRTD', 'MISSED')
  - Include work orders that never reached completion status
  - Provide completion timeline AND responsible party information

Row Grain:
  One row per work order within the target date range.

Assumptions:
  - Work orders are filtered by site 'FWN' AND specific work types (CA, PM, RQL)
  - Completion status is tracked via WOSTATUS table WITH specific status VALUES
  - Most recent completion status is used if multiple completion events exist
  - Work orders without completion status records are marked AS 'NEVER_COMPLETED'

Parameters:
  @start_date: Start of target completion date range (2025-08-01)
  @end_date: END of target completion date range (2025-09-01)

Filters:
  - Site: FWN only
  - Work order class: WORKORDER OR ACTIVITY
  - Task filter: Non-task work orders only (istask = 0)
  - Work types: CA (Corrective Action), PM (Preventive Maintenance), RQL (Request)
  - Target completion date: Within specified range
  - Report date: Optional filter for work order creation date

Security:
  - Read-only; no sensitive columns exposed

Version Control:
  - Store under /sql/work_orders WITH documentation under /docs/work_orders

Change Log:
  2025-10-07  [Your Name]  Initial version: Fixed INNER JOIN issue that excluded work orders
                           without completion status. Added LEFT JOIN WITH subquery to capture
                           all work orders including those never completed. Simplified date
                           range logic AND improved completion status tracking.
*/

-- Date range parameters

DECLARE @start_date AS DATETIME2 = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-18, +0)  -- Start of target date range
DECLARE @end_date AS DATETIME2 =  DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-0, +0)  -- END of target date range
DECLARE @cutoff_date AS DATE = '2024-01-01'


SELECT  -- Work Order Identification
	w.wonum AS work_order
	,w.description AS wo_description
	,w.status AS current_status
	,w.worktype AS work_type

	-- Asset Information
	,w.assetnum AS asset_num
	,w.location AS asset_location
	,w.jpnum AS job_plan_num

	-- Current Status Information
	,w.changeby AS curr_stat_changeby
	,w.changedate AS curr_stat_changedate

	-- Work Order Details
	,w.pmnum AS wo_pm_num
	,w.targcompdate AS target_date
	,w.actfinish AS act_finish
	,w.siteid AS wo_siteid
	,w.owner AS wo_owner
	,w.assignedownergroup AS wo_assigned_group
	,w.fnlconstraint AS finish_no_later

	-- Completion status information
	,CASE 
		WHEN comp_status.status IS NOT NULL THEN comp_status.status
		ELSE 'NEVER_COMPLETED'
	END AS completion_status
	,comp_status.changedate AS completion_date
	,comp_status.changeby AS completion_changeby

	-- Additional Information
	,w.reportdate AS report_date
FROM dbo.workorder AS w

	-- LEFT JOIN to find the most recent completion status (if any)
    -- This ensures work orders without completion status are still included
	LEFT JOIN (
		SELECT ws.siteid
			,ws.wonum
			,ws.status
			,ws.changedate
			,ws.changeby,
			-- Rank by most recent completion status change
			ROW_NUMBER() OVER (
				PARTITION BY ws.siteid, ws.wonum 
				ORDER BY ws.changedate DESC
			) AS rn
		FROM dbo.wostatus ws
		WHERE ws.status IN ('COMP', 'CORRECTED', 'CORRTD', 'MISSED')  -- Completion statuses only
	) comp_status 
ON w.siteid = comp_status.siteid AND w.wonum = comp_status.wonum AND comp_status.rn = 1  -- Most recent completion status only
WHERE 
	 -- Site AND Work Order Type Filters
    w.siteid = 'FWN'                                    -- FWN site only
    AND w.woclass IN ('WORKORDER','ACTIVITY')          -- Standard work order classes
    AND w.istask = 0                                    -- Exclude task records
    AND w.worktype IN ('CA','PM','RQL')                -- Specific work types
    
    -- Date Range Filter
    AND w.targcompdate > @start_date                    -- After start date
    AND w.targcompdate <= @end_date                     -- ON OR before END date
    
    -- Optional Report Date Filter (adjust AS needed)
    AND (w.reportdate IS NULL OR w.reportdate >= @cutoff_date)

ORDER BY 
	w.targcompdate,     -- Primary sort by target completion date
    w.wonum;            -- Secondary sort by work order number