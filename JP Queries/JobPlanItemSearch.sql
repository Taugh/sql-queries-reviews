USE max76PRD

SELECT DISTINCT j.jpnum,
	j.description,
	m.itemnum,
	i.description
FROM dbo.jobplan AS j
	INNER JOIN dbo.jobmaterial AS m
ON j.siteid = m.siteid AND j.jpnum = m.jpnum
	INNER JOIN dbo.item AS i
ON m.itemnum = i.itemnum
WHERE j.siteid = 'FWN' AND j.status = 'ACTIVE' AND m.itemnum is NOT NULL