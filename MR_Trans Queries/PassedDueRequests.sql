USE max76PRD
GO

-- Locates requested items that are 2 days pasted their required by date
SELECT requestnum AS 'Request #'
	,itemnum AS 'Item #'
	,description AS 'Description'
	,wonum AS 'Work Order'
	,mrnum AS 'MR #'
	,requestedby AS 'Requested By'
	,requireddate AS 'Required By'
FROM dbo.invreserve AS r
WHERE siteid = 'FWN' AND location = 'FWNCS' AND requireddate < DATEADD(DAY,-2,GETDATE())