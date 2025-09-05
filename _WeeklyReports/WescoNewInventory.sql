USE max76PRD

/******************************************************************************************
Query Name       :WescoNewInventory.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\_WeeklyReports\WescoNewInventory.sql
     Repository  : https://github.com/Taugh/sql-queries-reviews/blob/main/_WeeklyReports/WescoNewInventory.sql
Author           : Troy Brannon
Date             : 2025-09-05
Version          : 1.0

Purpose          : Identify newly added inventory items within the last 7 days for specific
                   sites and locations. Filters by active status and audit type 'I'.

Row Grain        : One row per unique itemnum per siteid.

Assumptions      : 
                   - Only items with status 'ACTIVE' are considered.
                   - Inventory changes are tracked via invstatus.changedate.
                   - Audit type 'I' in a_inventory indicates new item creation.
                   - Site and location filters are predefined via table variables.

Parameters       : 
                   - @RecentDate: 7-day window from current date.
                   - @site: Table variable containing site IDs.
                   - @location: Table variable containing location IDs.

Filters          : 
                   - itemsetid = 'IUS'
                   - siteid and location must match provided filters.
                   - status = 'ACTIVE'
                   - changedate >= @RecentDate
                   - eaudittype = 'I'

Security         : No sensitive data exposed. Ensure access to inventory, item, invstatus,
                   invvendor, chartofaccounts, and a_inventory tables is properly controlled.

Version Control  : Stored in GitHub repository 'sql-queries-reviews'
                   Branch: main
                   Last Reviewed: 2025-09-05 by Troy Brannon

Change Log       : 
                   - 2025-09-05: Initial header added and query reviewed for structure and clarity.
******************************************************************************************/

-- Declare date variable for 7-day window
DECLARE @RecentDate DATETIME = DATEADD(DAY, -7, CAST(GETDATE() AS DATE));

-- Define site filter
DECLARE @site TABLE (siteid VARCHAR(8));
INSERT INTO @site(siteid) VALUES ('ASPEX'), ('==FWN');

-- Define location filter
DECLARE @location TABLE (location VARCHAR(8));
INSERT INTO @location(location) VALUES ('ASPCS'), ('--FWNCS');

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
FROM inventory AS i
INNER JOIN item AS t
    ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
INNER JOIN invstatus AS s
    ON i.itemnum = s.itemnum AND i.siteid = s.siteid
INNER JOIN invvendor AS v
    ON i.itemnum = v.itemnum AND i.siteid = v.siteid
INNER JOIN chartofaccounts AS c
    ON i.glaccount = c.glaccount AND i.orgid = c.orgid
INNER JOIN a_inventory AS a
    ON i.itemnum = a.itemnum AND i.siteid = a.siteid
WHERE 
    i.siteid IN (SELECT siteid FROM @site)
    AND i.itemsetid = 'IUS'
    AND i.location IN (SELECT location FROM @location)
    AND i.status = 'ACTIVE'
    AND s.changedate >= @RecentDate
    AND a.eaudittype = 'I';
	