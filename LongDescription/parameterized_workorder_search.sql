
-- Parameterized work order search query for automation

DECLARE @SiteID NVARCHAR(10) = 'FWN';
DECLARE @Status NVARCHAR(20) = 'FLAGGED';
DECLARE @WorkType NVARCHAR(20) = NULL;  -- Example: 'PM'
DECLARE @LogType NVARCHAR(50) = NULL;   -- Example: 'RISK ASSESSMENT'
DECLARE @DescriptionExclude NVARCHAR(100) = NULL;  -- Example: '%late%'

SELECT
    w.wonum,
    w.description,
    w.status,
    w.worktype,
    w.assetnum,
    w.location,
    w.jpnum,
    w.actfinish,
    w.fnlconstraint,
    s.memo,
    l.logtype,
    l.description,
    d.ldtext
FROM dbo.workorder AS w
INNER JOIN dbo.wostatus AS s
    ON w.siteid = s.siteid AND w.wonum = s.wonum
INNER JOIN dbo.worklog AS l
    ON w.siteid = l.siteid AND w.wonum = l.recordkey
INNER JOIN dbo.longdescription AS d
    ON w.workorderid = d.ldkey AND d.ldownertable = 'WORKORDER'
WHERE w.siteid = @SiteID
  AND w.woclass IN ('WORKORDER', 'ACTIVITY')
  AND w.istask = 0
  AND s.status = @Status
  AND (@WorkType IS NULL OR w.worktype = @WorkType)
  AND (@LogType IS NULL OR l.logtype = @LogType)
  AND (@DescriptionExclude IS NULL OR l.description NOT LIKE @DescriptionExclude)
  AND (
      d.ldtext LIKE N'% PM %'
      OR d.ldtext LIKE N'CM'
      OR d.ldtext LIKE N'WO'
  )
ORDER BY w.wonum;
