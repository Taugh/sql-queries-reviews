USE max76PRD

-- Declare reusable date variables
DECLARE @StartDate DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0);
DECLARE @EndDate   DATETIME2 = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0);

-- Count of Item Requests Filled Late
SELECT DISTINCT(l.invusenum) AS [Usage Record]
	,invuselinenum AS [Line #]
	,l.itemnum AS [Item Number]
	,l.description AS [Description]
	,m.requireddate AS [Required By Date]
	,l.actualdate AS [Issued Date]
	,u.statusdate AS [Status Date]
FROM dbo.invuse AS u
	INNER JOIN invuseline AS l
ON u.siteid = l.tositeid and u.invusenum = l.invusenum
	INNER JOIN mrline AS m
ON l.tositeid = m.siteid AND l.mrnum = m.mrnum
WHERE status NOT IN ('CAN') AND u.siteid = 'FWN'
  AND EXISTS (
      SELECT 1
      FROM dbo.invuseline
      WHERE invuseline.invusenum = u.invusenum
        AND invuseline.siteid = u.siteid
        AND actualdate >= @StartDate AND actualdate < @EndDate
        AND EXISTS (
            SELECT 1
            FROM dbo.mrline
            WHERE mrline.siteid = invuseline.tositeid
              AND mrline.mrnum = invuseline.mrnum
              AND mrline.mrlinenum = invuseline.mrlinenum
              AND CAST(mrline.requireddate AS DATE) < CAST(invuseline.actualdate AS DATE)
             -- AND mrline.requireddate <= u.statusdate
        )
  );


SELECT DISTINCT(l.invusenum) AS [Usage Record]
FROM dbo.invuse AS u
	INNER JOIN invuseline AS l
ON u.siteid = l.tositeid and u.invusenum = l.invusenum
	INNER JOIN mrline AS m
ON l.tositeid = m.siteid AND l.mrnum = m.mrnum
WHERE status NOT IN ('CAN') AND u.siteid = 'FWN'
  AND EXISTS (
      SELECT 1
      FROM dbo.invuseline
      WHERE invuseline.invusenum = u.invusenum
        AND invuseline.siteid = u.siteid
        AND actualdate >= @StartDate AND actualdate < @EndDate
        AND EXISTS (
            SELECT 1
            FROM dbo.mrline
            WHERE mrline.siteid = invuseline.tositeid
              AND mrline.mrnum = invuseline.mrnum
              AND mrline.mrlinenum = invuseline.mrlinenum
              AND CAST(mrline.requireddate AS DATE) < CAST(invuseline.actualdate AS DATE)
             -- AND mrline.requireddate <= u.statusdate
        )
  );