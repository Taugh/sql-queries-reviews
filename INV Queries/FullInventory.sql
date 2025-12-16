USE max76PRD

SELECT i.itemnum
	  ,t.description
	  ,i.status
	  ,i.siteid
FROM dbo.inventory AS i
	INNER JOIN dbo.item AS t
ON i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid
WHERE i.siteid = 'FWN' AND i.location = 'FWNCS' AND i.
status != 'OBSOLETE'