USE max76PRD
GO

-- Purpose: Budget report showing reorder status, inventory levels, AND usage history
-- Notes:
--   - Filters for active items in FWNCS storeroom
--   - Joins inventory, item, AND invbalances tables

SELECT 
    i.itemnum AS [Item Number],
    t.description AS [Item Description],
    i.location AS [Storeroom],
    i.status AS [Status],
    i.reorder AS [Reorder],
    i.orderunit AS [Order Unit],
    i.issueunit AS [Issue Unit],
    b.curbal AS [Current Balance],
    i.minlevel AS [Reorder Point],
    i.orderqty AS [Economic Order Qty],
    i.issueytd AS [Issued YTD],
    i.issue1yrago AS [Issued Last Year]
FROM dbo.inventory AS i
INNER JOIN dbo.item AS t
    ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
INNER JOIN dbo.invbalances AS b
    ON i.itemnum = b.itemnum AND i.siteid = b.siteid
WHERE 
    i.siteid = 'FWN' 
    AND i.location = 'FWNCS' 
    AND i.itemsetid = 'IUS' 
    AND i.status != 'OBSOLETE';