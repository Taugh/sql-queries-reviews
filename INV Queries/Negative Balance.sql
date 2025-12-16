USE max76PRD

/*=======================================================================================
Query Name: Negative Balance Occurrences

Purpose: Identify inventory items WITH negative current balance for review AND correction.

Row Grain: One row per item-location-bin-lot combination.

Assumptions:
    - Current balance is stored in `curbal` column of `invbalances`.
    - Negative balances indicate discrepancies requiring investigation.

Parameters:
    - siteid

Filters:
    - curbal < 0

Security:
    - Ensure user has read-only access to inventory tables.

Version Control:
    - v1.0 | 2025-12-02 | Initial creation.
	- File Path: /inventory/negative_balance_occurrences.sql

Change Log:
    - 2025-12-02 | Added metadata header AND financial impact calculation.
=======================================================================================*/

DECLARE @site1 VARCHAR(3) = 'FWN';
DECLARE @site2 VARCHAR(5) = 'ASPEX';
DECLARE @active_site VARCHAR(5) = @site1;  -- change site here

SELECT
    itemnum,
    location,
    siteid,
    curbal AS current_balance,
    binnum,
    lotnum
FROM
    dbo.invbalances
WHERE siteid = @active_site
    AND curbal < 0
ORDER BY
    siteid, location, itemnum;
