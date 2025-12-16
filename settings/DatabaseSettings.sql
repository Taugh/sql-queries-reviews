USE max76PRD

--SELECT name
--	,description
--FROM sys.fn_helpcollations();

SET LANGUAGE British
SELECT CAST('02/12/2025' AS DATE)

SET LANGUAGE US_English
SELECT CAST('02/12/2025' AS DATE)

SELECT name, current_utc_offset, is_currently_dst
FROM sys.time_zone_info;