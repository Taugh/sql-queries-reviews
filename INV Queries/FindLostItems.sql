USE max76PRD
GO

--Finds all receipts for specfied items AND time frame
SELECT ponum
	,itemnum
	,description
	,issuetype
	,qtyrequested
	,quantity
	,rejectqty
	,curbal
	,eauditusername
	,eaudittimestamp
	,eaudittype
	,location
	,tostoreloc
FROM dbo.a_matrectrans
WHERE itemnum in ('10032599','111480') AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-12,+0) AND siteid = 'FWN' AND issuetype = 'RECEIPT'
ORDER BY actualdate desc;

--Returns all POs for specified item AND time frame
SELECT ponum
	,itemnum
	,description
	,issuetype
	,qtyrequested
	,quantity
	,rejectqty
	,qtyoverreceived
	,statusdate
	,location
	,tostoreloc
FROM dbo.matrectrans
WHERE itemnum in ('10032599','111480') AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-12,+0) AND siteid = 'FWN'
ORDER BY actualdate DESC;

--Returns usage type for specified item AND time frame
SELECT ponum
	,itemnum
	,description
	,issuetype
	,qtyrequested
	,quantity
	,curbal
	,enterby
	,actualdate
	,location
	,storeloc
FROM dbo.matusetrans
WHERE itemnum in ('10032599','111480') AND actualdate >= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())-12,+0) AND siteid = 'FWN'
ORDER BY actualdate DESC;