USE max76PRD


/*
  =============================================
  Query: Future Work Orders with Asset & Location Context
  Purpose: Identify upcoming work orders with responsible party and asset/location details
  Author: Troy Brannon
  Date: 2025-09-04
  Version: 1.0
  =============================================
*/

-- Declare date range for future work orders
DECLARE @StartDate DATETIME = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0);
DECLARE @EndDate DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0);

-- Future Work Orders
SELECT 
    w.wonum AS 'Work Order',
    w.description AS 'WO Description',
    w.status AS 'WO Status',
    w.worktype AS 'WO Work Type',
    w.assetnum AS 'Asset Number',
    a.description AS 'Asset Description',
    a.location AS 'Location',
    l.description AS 'Location Description',
    w.targcompdate AS 'Target Complete Date',
    w.assignedownergroup AS 'Owner Group',
    s.displayname AS 'Responsible Party'
FROM workorder AS w
INNER JOIN asset AS a
    ON w.siteid = a.siteid AND w.assetnum = a.assetnum
INNER JOIN persongroupteam AS p
    ON w.assignedownergroup = p.persongroup
INNER JOIN person AS s
    ON p.respparty = s.personid
INNER JOIN locations AS l
    ON a.siteid = l.siteid AND a.location = l.location
WHERE w.siteid = 'FWN'
  AND w.woclass IN ('WORKORDER', 'ACTIVITY')
  AND w.istask = 0
  AND w.historyflag = 0
  AND w.status NOT IN ('COMP', 'CORRTD', 'PENREV', 'PENDQA', 'REVWD')
  AND w.worktype IN ('CA', 'PM', 'RM', 'RQL')
  AND w.targcompdate > @StartDate AND w.targcompdate <= @EndDate
  AND p.groupdefault = 1
ORDER BY w.status;