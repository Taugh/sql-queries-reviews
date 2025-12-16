USE max76PRD
GO

SELECT wonum
FROM dbo.workorder
WHERE siteid = 'FWN' AND workorderid in ('985326','1023073','1188142','12260259','12643436','12875792')
	AND woclass in ('WORKORDER','ACTIVITY') AND istask = 0
