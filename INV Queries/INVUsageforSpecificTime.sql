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
FROM sbo.matusetrans
WHERE siteid = 'FWN' 
	AND actualdate >= dateadd(year,datediff(year,0,getdate())+0,0)
	AND actualdate < dateadd(month,datediff(month,0,getdate())+0,0)