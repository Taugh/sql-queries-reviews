USE max76PRD


SELECT ponum
	,receipts
	,status
FROM dbo.po
WHERE orgid = 'US'
	AND siteid = 'FWN'
	AND ponum IN ('43539')
	AND status = 'APPR'


	