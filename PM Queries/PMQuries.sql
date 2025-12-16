USE max76PRD
GO

--Returns all PMs for specificed asset(s)
SELECT assetnum AS 'Asset Number'
	,pmnum AS 'PM Number'
	,description AS Description
	,worktype AS 'Work Type'
	,jpnum AS 'Job Plan Number'
	,gmpcritical AS 'GMP Critical'
	,frequency AS Frequency
	,frequnit AS 'Frequency Unit'
	,nextdate AS 'Next Date'
FROM dbo.pm
WHERE assetnum in ('10040','10705','13512') AND siteid = 'FWN' AND status = 'ACTIVE'
ORDER BY assetnum;

--Basic information for specific PM
SELECT pmnum AS PM
	,description AS 'Description'
	,location AS Location
	,assetnum AS Asset
	,lastcompdate AS 'Last Complete Date'
	,nextdate AS 'Next Due Date'
FROM dbo.pm
WHERE siteid = 'FWN' AND pmnum in ('E3436SS','E3436WS')

--Audit trail for selected PM
SELECT pmnum
	,changedate 
	,changeby 
	,description 
	,worktype 
	,frequency 
	,frequnit 
	,leadtime 
	,stconoffset 
	,fnconoffset
	,nextdate 
FROM dbo.a_pm
WHERE siteid = 'FWN' AND pmnum = '19936'
ORDER BY changedate desc;

--PMs WITH dates no ON the 1st 
SELECT pmnum
	,nextdate
FROM dbo.pm
WHERE frequnit NOT in ('DAYS','WEEKS') AND (DAY(nextdate) != 01) AND status = 'ACTIVE' AND siteid = 'FWN'