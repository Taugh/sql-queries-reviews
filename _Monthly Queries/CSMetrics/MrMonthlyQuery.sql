USE max76PRD
GO

--Count the number of MRs for given time frame
SELECT COUNT(mrnum) AS 'Total requisition'
FROM dbo.mr
WHERE siteid = 'FWN' AND status NOT in ('CAN','DRAFT','WAPPR')AND enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND enterdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0);

--Shows all MRs for the previous MONTH
SELECT mrnum
	,description
	,enterdate
	,status
	,requestedby
	,requestedfor
	,totalcost
FROM dbo.mr
WHERE siteid = 'FWN' AND status NOT in ('CAN','DRAFT') AND enterdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,+0)
	AND enterdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,+0)
ORDER BY enterby asc;

--Counts the number of item requests that were NOT filled ON time
SELECT COUNT(invusenum) AS 'Filled Late'
FROM dbo.invuse
WHERE (status NOT in ('CAN') AND siteid = 'FWN') 
	  AND (exists 
			(SELECT 1
			 FROM dbo.invuseline 
			 WHERE ((actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-1,0)) AND actualdate < DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0,0)) 
				AND (invuseline.invusenum = invuse.invusenum AND invuseline.siteid = invuse.siteid) 
				AND (exists 
						(SELECT 1 
						 FROM dbo.mrline 
						 WHERE mrline.siteid = invuseline.tositeid AND mrline.mrnum = invuseline.mrnum AND mrline.mrlinenum = invuseline.mrlinenum
									AND mrline.requireddate < DATEADD(HOUR,DATEDIFF(HOUR,0,invuseline.actualdate)-1,+0) AND requireddate < statusdate
						)
					)
			)
		  );