-- SQLCMD Variables - Use in SQLCMD mode in SSMS (Query > SQLCMD Mode)
-- Include in queries with:  :r "settings\CommonVariables_SQLCMD.sql"

:setvar ActiveSite "FWN"
:setvar AlternateSite "ASPEX"
:setvar MainStoreroom "FWNCS"
:setvar Database "max76PRD"
:setvar Username "BRANNTR1"

-- Example Usage:
-- SELECT * FROM workorder WHERE siteid = '$(ActiveSite)'
