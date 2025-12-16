USE max76PRD

SELECT wonum
	, description
	, status
	,targcompdate
	,assignedownergroup
FROM dbo.workorder
WHERE siteid = 'FWN' AND wonum in('1079192','1079197','1091016','1093968','1093973','1096610','1096615','1099503','1094499','1094502','1101912','1105555','1105560')
