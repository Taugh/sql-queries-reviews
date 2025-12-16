USE max76PRD
GO

SELECT m.mrnum AS 'Req#'
	,m.wonum AS 'WO#'
	,m.requestedby AS 'Requested by'
	,m.description AS 'Description'
	,l.mrlinenum AS 'Req line item number'
	,l.description AS 'Req line item Description'
	,l.qty AS 'Req line item QTY'
	,m.requireddate AS 'Need by Date'
FROM dbo.mr AS m
	INNER JOIN dbo.mrline AS l
ON m.mrnum = l.mrnum AND m.siteid = l.siteid
WHERE m.siteid = 'FWN' AND m.description like '%2025 Summer Shutdown%' --Change MR description 
