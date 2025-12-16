--Searches vendor table for items WITH supplied model number

SELECT DISTINCT v.itemnum
	,v.manufacturer
	,v.modelnum
	--,status
	--,i.minlevel
	--,i.orderqty
FROM dbo.invvendor AS v
--	INNER JOIN dbo.inventory AS i
--ON v.siteid = i.siteid AND v.itemnum = i.itemnum
WHERE v.siteid = 'FWN' --AND i.status != 'OBSOLETE'
	AND v.modelnum in ('521015','188780','516145','454743','454757','454745','188755','207508','407184','407183','407182','248567','250250','250251','248716','104462','112189','228604','232588','248739','248740','160703','100589','104059','104065','104130','111333','130473','245841','283468','308539','509711','519523','518020','353116','364550','519864','441417')
