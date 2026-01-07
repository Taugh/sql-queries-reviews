USE max76PRD

DECLARE @site1 VARCHAR(3) = 'FWN';
DECLARE @site2 VARCHAR(5) = 'ASPEX';
DECLARE @active_site VARCHAR(5) = @site1;  -- change site here

DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0);
DECLARE @EndDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 30, 0);

/* === Work types to include === */
DECLARE @WorkTypes TABLE (worktype VARCHAR(8));
INSERT INTO @WorkTypes (worktype) VALUES ('CA'), ('PM'), ('RM'), ('RQL');

/* === Statuses to exclude from certain metrics === */
DECLARE @ExcludedStatus TABLE (status VARCHAR(8));
INSERT INTO @ExcludedStatus (status)
VALUES ('COMP'), ('CORRTD'), ('PENRVW'), ('PENDQA'), ('REVWD');

-- Work Orders
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
FROM dbo.workorder AS w
	LEFT JOIN dbo.asset AS a
ON w.siteid = a.siteid AND w.assetnum = a.assetnum
	LEFT JOIN dbo.persongroupteam AS p
ON w.assignedownergroup = p.persongroup
	LEFT JOIN dbo.person AS s
ON p.respparty = s.personid
	LEFT JOIN dbo.locations AS l
ON a.siteid = l.siteid AND a.location = l.location
	INNER JOIN @WorkTypes AS wt
ON w.worktype = wt.worktype
WHERE w.siteid = @active_site
  AND w.woclass IN ('WORKORDER', 'ACTIVITY')
  AND w.istask = 0
  AND w.historyflag = 0
  AND w.targcompdate <= @StartDate AND w.targcompdate >= @EndDate
  AND p.groupdefault = 1
  /* Exclude statuses using NOT EXISTS (avoids ambiguity and subqueries in aggregates) */
  AND NOT EXISTS (
        SELECT 1 
		FROM @ExcludedStatus AS es
        WHERE es.status = w.status
  )
ORDER BY w.wonum;