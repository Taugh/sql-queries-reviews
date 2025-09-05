USE max76PRD

/*
  =============================================
  Query: New Inventory Items Report
  Purpose: Identify items created in the last 7 days with vendor and GL account details
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare date variable for 7-day window
DECLARE @RecentDate DATETIME = DATEADD(DAY, -7, CAST(GETDATE() AS DATE));

-- Define site filter
DECLARE @site TABLE (siteid VARCHAR(8));
INSERT INTO @site(siteid) VALUES ('--ASPEX'), ('FWN');

-- Define location filter
DECLARE @location TABLE (location VARCHAR(8));
INSERT INTO @location(location) VALUES ('--ASPCS'), ('FWNCS');

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
	