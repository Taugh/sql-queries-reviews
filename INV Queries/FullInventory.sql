USE max76PRD

SELECT i.itemnum
	  ,t.description
	  ,i.status
	  ,i.siteid
	  ,i.glaccount
	  ,lastcost
	  ,lastdate
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
	LEFT JOIN invvendor AS v
ON i.itemnum = v.itemnum and i.siteid = v.siteid
WHERE i.siteid = 'FWN' AND i.location = 'FWNCS' AND i.
status != 'OBSOLETE'