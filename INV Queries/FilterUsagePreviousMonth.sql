USE max76PRD

-- This query looks for specific items (filters) AND returns the usage for the previous month

SELECT itemnum
	,storeloc
	,transdate
	,actualdate
	,quantity
	,curbal
	,physcnt
	,unitcost
	,actualcost
	,ponum
	, conversion
	,assetnum
	,enterby
	,issueto
	,binnum
	,lotnum
	,issuetype
	,gldebitacct
	,linecost
	,currencyunitcost
	,currencylinecost
	,location
	,description
	,qtyrequested
	,orgid
	,siteid
FROM dbo.matusetrans
WHERE siteid = 'FWN' AND storeloc = 'FWNCS' 
	AND itemnum in ('122264','122507','500040','500049','500050','500078','500097',		'500170','500239','500339','500344','500347',
					'500388','500408','500503','500629','500641','500871','500994','501058','10000183','10032241')
	AND issuetype in ('ISSUE','RETURN') AND transdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1, 0) 
	AND transdate < DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+0, 0)