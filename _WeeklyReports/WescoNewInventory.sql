USE max76PRD
GO

-- New Inventory Items Report
-- Finds all items created within the last 7 days for specified sites and locations
-- Includes item details, GL account info, and vendor data

-- Define site filter
DECLARE @site TABLE (siteid VARCHAR(8));
INSERT INTO @site(siteid) VALUES ('ASPEX'), ('--FWN');

-- Define location filter
DECLARE @location TABLE (location VARCHAR(8));
INSERT INTO @location(location) VALUES ('ASPCS'), ('--FWNCS');

-- Query for new inventory items
SELECT DISTINCT 
    i.itemnum AS Item,
    t.description AS Description,
    i.minlevel AS Min,
    i.orderqty AS Max,
    i.siteid AS 'Who Owns Inventory',
    c.accountname AS 'GL Account Description',
    i.glaccount AS 'GL Account',
    v.manufacturer AS Manufacturer,
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
    AND changedate >= DATEADD(DAY, DATEDIFF(DAY, 0, CURRENT_TIMESTAMP) - 7, 0)
    AND a.eaudittype = 'I';
	--and i.itemnum in ('10002035','10002036','10002037','10002040','10002041','10002042','10002123','10002124','10002127')  -- For those existing items CS forgot to tell Wesco about