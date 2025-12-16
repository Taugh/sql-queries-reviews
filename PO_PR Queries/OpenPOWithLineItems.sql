USE max76PRD

SELECT p.ponum AS [PO Number],
	p.description AS [PO Descrption],
	p.receipts AS [PO Receipts],
	p.status AS [PO Status],
	p.siteid AS [Site ID],
	l.polinenum AS [PO Line Number],
	itemnum AS [Item Number],
	l.description AS [Item Description],
	orderqty AS [Order QTY],
	ISNULL(receivedqty, 0) AS [Received QTY]
FROM dbo.po AS p
	INNER JOIN dbo.poline AS l
ON p.siteid = l.siteid AND p.ponum = l.ponum
WHERE p.siteid = 'FWN' AND l.orgid = 'US' AND l.storeloc = 'FWNCS' AND p.status = 'APPR' AND l.itemnum != 'SPOTBUY'
	AND historyflag = 0 AND p.receipts NOT IN ('COMPLETE') AND l.receiptscomplete = 0
	AND l.revisionnum = (SELECT MAX(revisionnum)
						 FROM dbo.po po2 
						 WHERE l.siteid = po2.siteid AND l.ponum = po2.ponum 
							AND po2.status NOT in (SELECT value
												   FROM dbo.synonymdomain 
												   WHERE domainid='POSTATUS' AND maxvalue in ('CAN')
												  )
						)
ORDER BY [PO Number];