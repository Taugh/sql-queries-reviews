USE max76PRD
GO

--Returns all MRs entered by person(s) AND time frame 
SELECT mrnum
	,description
	,enterdate
	,status
	,requestedby
	,requestedfor
	,totalcost
FROM dbo.mr
WHERE siteid = 'FWN' AND enterby = 'VIERACA3' AND status NOT in ('CAN','DRAFT')
	AND enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND enterdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)