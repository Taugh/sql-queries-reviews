USE max76PRD
GO

--Reserved items without MR description
SELECT requestnum AS 'Request #'
	,mrnum AS 'MR #'
	,mrlinenum AS 'MR Line'
	,itemnum AS 'Item #'
	,description AS 'Item Description'
	,wonum AS 'Work Order'
	,reservedqty AS 'Requested QTY'
	,stagedqty AS 'Staged QTY'
	,actualqty AS 'Issued QTY'
	,(reservedqty - stagedqty - actualqty) AS 'Still Need'
FROM dbo.invreserve
WHERE siteid = 'FWN' AND location = 'FWNCS';

--Reserved items WITH MR description
SELECT i.requestnum AS 'Request #'
	,i.mrnum AS 'MR #'
	,m.description AS 'MR Description'
	,i.mrlinenum AS 'MR Line'
	,i.itemnum AS 'Item #'
	,i.description AS 'Item Description'
	,i.wonum AS 'Work Order'
	,i.reservedqty AS 'Requested QTY'
	,i.stagedqty AS 'Staged QTY'
	,i.actualqty AS 'Issued QTY'
	,(i.reservedqty - i.stagedqty - i.actualqty) AS 'Still Need'
FROM dbo.invreserve AS i
	LEFT JOIN dbo.mr AS m
ON i.mrnum = m.mrnum
WHERE i.siteid = 'FWN' AND i.location = 'FWNCS' AND m.mrnum in('11457','11458','11459','11460','11491','11492','11493','11494','11526','11555','11556','11557','11606','11625','11843','11844','11845','11897','11898','12080','12090','12158','12159','12464','12465','12467','12468','12469','12972','12984','13086','13104','13114')
