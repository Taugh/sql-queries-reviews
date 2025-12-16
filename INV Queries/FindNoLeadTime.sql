USE Max76PRD
GO


SELECT i.itemnum
	,status
	,i.siteid
	,i.location
	,i.status
	,v.manufacturer
FROM dbo.inventory AS i
	JOIN dbo.invvendor AS v
ON i.itemnum = v.itemnum AND i.itemsetid = v. itemsetid AND i.siteid = v.siteid
WHERE i.siteid = 'FWN' AND location = 'FWNCS' AND i.status != 'OBSOLETE' AND (deliverytime = 0 OR deliverytime is null AND i.status != 'OBSOLETE') 
ORDER BY itemnum;