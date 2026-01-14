-- Example: Using DECLARE variables approach (Recommended - works in all modes)
USE max76PRD
GO

-- Include common variables
:r "settings\CommonVariables_Declare.sql"

-- Now use the variables in your query
SELECT COUNT(DISTINCT wonum) AS [Work Orders This Year]
FROM dbo.workorder
WHERE siteid = @ActiveSite
	AND woclass IN ('WORKORDER', 'ACTIVITY')
	AND historyflag = 0 
	AND istask = 0
	AND reportdate >= @CurrentYearStart
	AND reportdate < @CurrentYearEnd
	AND owner = @Username;

-- Variables can be overridden if needed
SET @ActiveSite = 'ASPEX'

SELECT COUNT(*) AS [ASPEX Work Orders]
FROM dbo.workorder
WHERE siteid = @ActiveSite
	AND reportdate >= @CurrentYearStart;
