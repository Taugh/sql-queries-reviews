USE max76PRD
GO

-- Items issued for the fixed dates below
SELECT refwo
	,itemnum
	,description
	,enterby
	,actualdate
	,quantity
	,unitcost
	,linecost
FROM matusetrans
WHERE siteid = 'FWN' 
	and actualdate >= dateadd(year,datediff(year,0,getdate())+0,0)
	and actualdate < dateadd(month,datediff(month,0,getdate())+0,0)