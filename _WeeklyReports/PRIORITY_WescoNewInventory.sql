USE max76PRD

/************************************************************************************************************************
Query Name       :WescoNewInventory.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\_WeeklyReports\WescoNewInventory.sql
     Repository  : https://github.com/Taugh/sql-queries-reviews/blob/main/_WeeklyReports/WescoNewInventory.sql
Author           : Troy Brannon
Date             : 2025-09-05
Version          : 1.0

Purpose          : Identify newly added inventory items within the last 7 days for specific
                   sites AND locations. Filters by active status AND audit type 'I'.

Row Grain        : One row per unique itemnum per siteid.

Assumptions      : 
                   - Only items WITH status 'ACTIVE' are considered.
                   - Inventory changes are tracked via invstatus.changedate.
                   - Audit type 'I' in a_inventory indicates new item creation.
                   - Site AND location filters are predefined via table variables.

Parameters       : 
                   - @RecentDate: 7-day window FROM current date.
                   - @site: Table variable containing site IDs.
                   - @location: Table variable containing location IDs.

Filters          : 
                   - itemsetid = 'IUS'
                   - siteid AND location must match provided filters.
                   - status = 'ACTIVE'
                   - changedate >= @RecentDate
                   - eaudittype = 'I'

Security         : No sensitive data exposed. Ensure access to inventory, item, invstatus,
                   invvendor, chartofaccounts, AND a_inventory tables is properly controlled.

Version Control  : Stored in GitHub repository 'sql-queries-reviews'
                   Branch: main
                   Last Reviewed: 2025-09-05 by Troy Brannon

Change Log       : 
                   - 2025-09-05: Initial header added AND query reviewed for structure AND clarity.
************************************************************************************************************************/

-- Declare date variable for 7-day window

DECLARE @RecentDate DATETIME2 = DATEADD(DAY, -7, CAST(GETDATE() AS DATE));

-- Define site AND location filter
DECLARE @siteLocation TABLE (siteid VARCHAR(8), location VARCHAR(8));
INSERT INTO @siteLocation(siteid, location) VALUES 
    --('ASPEX', 'ASPCS')
    ('FWN', 'FWNCS')
    -- Add more pairs AS needed
    -- ('SITE3', 'LOC3')
;

-- Query for new inventory items
SELECT DISTINCT
    i.itemnum AS 'Item',
    t.description AS 'Description',
    i.minlevel AS 'Min',
    i.orderqty AS 'Max',
    i.siteid AS 'Who Owns Inventory',
    c.accountname AS 'GL Account Description',
    i.glaccount AS 'GL Account',
    v.manufacturer AS 'Manufacturer',
    v.modelnum AS 'Model Number',
    v.catalogcode AS 'Catalog Number',
    i.orderunit AS 'Order Unit'
FROM dbo.inventory AS i
INNER JOIN dbo.item AS t
    ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
INNER JOIN dbo.invstatus AS s
    ON i.itemnum = s.itemnum AND i.siteid = s.siteid
INNER JOIN dbo.invvendor AS v
    ON i.itemnum = v.itemnum AND i.siteid = v.siteid
INNER JOIN dbo.chartofaccounts AS c
    ON i.glaccount = c.glaccount AND i.orgid = c.orgid
INNER JOIN dbo.a_inventory AS a
    ON i.itemnum = a.itemnum AND i.siteid = a.siteid
-- Use one JOIN for siteid AND location:
INNER JOIN @siteLocation sl 
	ON i.siteid = sl.siteid AND i.location = sl.location
WHERE 
    i.itemsetid = 'IUS'
    AND i.status = 'ACTIVE'
    AND s.changedate >= @RecentDate
    AND a.eaudittype = 'I';
	