
-- Search work orders based ON flexible criteria
-- Returns work order details along WITH status logs AND long descriptions

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
WHERE w.siteid = 'FWN'
  AND w.woclass IN ('WORKORDER', 'ACTIVITY')
  AND w.istask = 0
  AND s.status = 'FLAGGED'
  -- Optional filters:
  -- AND w.status IN ('CLOSE')
  -- AND w.worktype = 'PM'
  -- AND l.logtype = 'RISK ASSESSMENT'
  -- AND l.description NOT LIKE '%late%'
  AND (
      d.ldtext LIKE N'% PM %'
      OR d.ldtext LIKE N'CM'
      OR d.ldtext LIKE N'WO'
  )
ORDER BY w.wonum;
