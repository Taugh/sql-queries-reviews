USE max76PRD
GO

SELECT wonum, siteid, status, worktype, assignedownergroup, owner, targcompdate, fnlconstraint, actfinish
FROM dbo.workorder AS w
WHERE siteid = 'FWN' AND status = 'PENRVW'AND woclass in ('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 
	AND NOT EXISTS
			(SELECT 1
			 FROM dbo.labtrans AS l
				INNER JOIN dbo.workorder AS w1
			 ON l.siteid = w1.siteid AND refwo = w1.wonum
			 WHERE l.siteid = w.siteid AND (refwo = w.wonum OR (w1.parent = w.wonum AND w1.istask = 1)))