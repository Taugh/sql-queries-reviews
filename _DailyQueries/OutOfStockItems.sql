USE max76PRD
GO


--Stockouts
SELECT DISTINCT r.itemnum
FROM invreserve AS r
	JOIN invbalances AS b
		ON r.itemnum = b.itemnum and r.location = b.location and r.siteid = b.siteid and r.itemsetid = b.itemsetid 
WHERE r.siteid = 'FWN' and r.location = 'FWNCS' and r.reservedqty > b.curbal 
	and DATEADD(HOUR,24,r.requireddate) < CURRENT_TIMESTAMP
	and r.requireddate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0.0)
ORDER BY r.itemnum;

--Orders not picked up within 48 hours
SELECT r.requestnum
	,r.itemnum
	,i.description
	,r.reservedqty
	,b.curbal
	,r.wonum
	,r.mrnum
	,r.requestedby
	,r.requireddate
FROM invreserve AS r
	JOIN invbalances AS b
		ON (r.itemnum = b.itemnum and r.location = b.location and r.siteid = b.siteid and r.itemsetid = b.itemsetid)
	JOIN item AS i
		ON (r.itemnum = i.itemnum and r.itemsetid = i.itemsetid)
WHERE r.siteid = 'FWN' and r.location = 'FWNCS' and r.reservedqty <= b.curbal 
	and DATEADD(HOUR,48,r.requireddate) < CURRENT_TIMESTAMP
ORDER BY itemnum;