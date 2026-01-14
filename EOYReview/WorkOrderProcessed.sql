USE max76PRD

USE max76PRD

SELECT COUNT(DISTINCT s.wonum) AS [Work Orders Processed]
FROM wostatus AS s
	INNER JOIN workorder AS w
ON s.wonum = w.wonum and s.siteid = w.siteid
WHERE s.siteid IN ('ASPEX','FWN')
	AND s.changeby IN ('BRANNTR1','SCHMIC2H')
	AND s.changedate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0)
	AND s.changedate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) + 0, 0)
	AND reportdate >= DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) - 1, 0)
	AND reportdate < DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP) + 0, 0)
	AND s.status in ('CAN','CLOSE','REVWD');
