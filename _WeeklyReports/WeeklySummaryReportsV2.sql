USE max76PRD
GO

SELECT
	--ProdMaint
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNAE','FWNLC1','FWNLC2','FWNPS')) 
			THEN 1 ELSE 0 END) AS 'ProdMaint EOW'
	
	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') AND assignedownergroup IN('FWNAE','FWNLC1','FWNLC2','FWNPS')) 
			THEN 1 ELSE 0 END) AS 'ProdMaint EOM'
	
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) 
				AND (targcompdate <= CURRENT_TIMESTAMP AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0)))
				AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND assignedownergroup IN('FWNAE','FWNLC1','FWNLC2','FWNPS'))
			THEN 1 ELSE 0 END) AS 'ProdMaint Risk Late'
	
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7','14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) 
				or (fnlconstraint <= CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) AND pluscfrequency between 5 AND 11 
				AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) 
				AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS')))and status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNAE','FWNLC1','FWNLC2','FWNPS'))
			THEN 1 ELSE 0 END) AS 'ProdMaint Risk Missed'
	
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNAE','FWNLC1','FWNLC2','FWNPS'))
			THEN 1 ELSE 0 END) AS 'ProdMaint Flagged'
			
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNAE','FWNLC1','FWNLC2','FWNPS'))
			THEN 1 ELSE 0 END) AS 'ProdMaint Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month			

--CritSys
SELECT
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNCSM','FWNMET','FWNWSM','FWNCS','FWNMNTSCH')) 
			THEN 1 ELSE 0 END) AS 'CritSys EOW'
	
	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') AND assignedownergroup IN('FWNCSM','FWNMET','FWNWSM','FWNCS','FWNMNTSCH')) 
			THEN 1 ELSE 0 END) AS 'CritSys EOM'
	
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) 
				AND (targcompdate <= CURRENT_TIMESTAMP AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0)))
				AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNCSM','FWNMET','FWNWSM','FWNCS','FWNMNTSCH'))
			THEN 1 ELSE 0 END) AS 'CritSys Risk Late'
			
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7','14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) 
				or (fnlconstraint <= CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) 
				AND pluscfrequency between 5 AND 11 AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS')))
				and status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNCSM','FWNMET','FWNWSM','FWNCS','FWNMNTSCH'))
			THEN 1 ELSE 0 END) AS 'CritSys Risk Missed'
	
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNCSM','FWNMET','FWNWSM','FWNCS','FWNMNTSCH'))
			THEN 1 ELSE 0 END) AS 'CritSys Flagged'
	
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNCSM','FWNMET','FWNWSM','FWNCS','FWNMNTSCH'))
			THEN 1 ELSE 0 END) AS 'CritSys Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month

--Production
SELECT
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS','FWNLCP4')) 
			THEN 1 ELSE 0 END) AS 'LC Prod EOW'
			
	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS','FWNLCP4')) 
			THEN 1 ELSE 0 END) AS 'LC Prod EOM'
			
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) 
				AND (targcompdate <= CURRENT_TIMESTAMP AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0)))
				AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS','FWNLCP4'))
			THEN 1 ELSE 0 END) AS 'Prod Risk Late'
			
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7','14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) 
				or (fnlconstraint <= CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) AND pluscfrequency between 5 AND 11 
				AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) 
				AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS')))and status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS','FWNLCP4'))
			THEN 1 ELSE 0 END) AS 'LC Prod Risk Missed'
			
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS','FWNLCP4'))
			THEN 1 ELSE 0 END) AS 'LC Prod Flagged'
			
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS','FWNLCP4'))
			THEN 1 ELSE 0 END) AS 'LC Prod Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month

-- Engineering
SELECT
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL','FWNAE','FWNAE2')) 
			THEN 1 ELSE 0 END) AS 'ENG EOW'
			
	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL','FWNAE','FWNAE2')) 
			THEN 1 ELSE 0 END) AS 'ENG EOM'
	
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) 
				AND (targcompdate <= CURRENT_TIMESTAMP AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0)))
				AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL','FWNAE','FWNAE2'))
			THEN 1 ELSE 0 END) AS 'ENG Risk Late'
	
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7','14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) 
				or (fnlconstraint <= CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) 
				AND pluscfrequency between 5 AND 11 AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS'))) 
				and status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL','FWNAE','FWNAE2'))
			THEN 1 ELSE 0 END) AS 'ENG Risk Missed'
			
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL','FWNAE','FWNAE2'))
			THEN 1 ELSE 0 END) AS 'ENG Flagged'
			
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL','FWNAE','FWNAE2'))
			THEN 1 ELSE 0 END) AS 'ENG Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month
	
-- PharmSurg
SELECT
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6','FWNPSP7')) 
			THEN 1 ELSE 0 END) AS 'PS Prod EOW'
			
	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6','FWNPSP7')) 
			THEN 1 ELSE 0 END) AS 'PS Prod EOM'
			
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (targcompdate <= CURRENT_TIMESTAMP 
				AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0))) AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6','FWNPSP7'))
			THEN 1 ELSE 0 END) AS 'PS Prod Risk Late'
	
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7','14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) or (fnlconstraint <= CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) AND pluscfrequency between 5 AND 11 AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS')))
				and status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6','FWNPSP7'))
			THEN 1 ELSE 0 END) AS 'PS Prod Risk Missed'
	
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6','FWNPSP7'))		
			THEN 1 ELSE 0 END) AS 'PS Prod Flagged'
	
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6','FWNPSP7'))
			THEN 1 ELSE 0 END) AS 'PS Prod Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month

-- QA/QC
SELECT
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNAST','FWNAST1','FWNCCM','FWNQACA','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI')) 
			THEN 1 ELSE 0 END) AS 'QA/QC EOW'

	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNAST','FWNAST1','FWNCCM','FWNQACA','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI'))
			THEN 1 ELSE 0 END) AS 'QA/QC EOM'
			
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (targcompdate <= CURRENT_TIMESTAMP 
				AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0))) AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNAST','FWNAST1','FWNCCM','FWNQACA','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI'))
			THEN 1 ELSE 0 END) AS 'QA/QC Risk Late'
	
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7', '14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) or (fnlconstraint <= CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) 	AND pluscfrequency between 5 AND 11 AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS'))) 
				and status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNAST','FWNAST1','FWNCCM','FWNQACA','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI'))
			THEN 1 ELSE 0 END) AS 'QA/QC Risk Missed'
	
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNAST','FWNAST1','FWNCCM','FWNQACA','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI'))
			THEN 1 ELSE 0 END) AS 'QA/QC Flagged'
	
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNAST','FWNAST1','FWNCCM','FWNQACA','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI'))
			THEN 1 ELSE 0 END) AS 'QA/QC Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month

-- OTHERS
SELECT
	SUM(CASE WHEN 
				(targcompdate <= DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+7, 0) AND targcompdate > DATEADD(DAY,DATEDIFF(DAY,0,CURRENT_TIMESTAMP)+0, 0) 
				AND (worktype IN('CA','PM','RM','RQL')) AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') 
				AND assignedownergroup IN('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP')) 
			THEN 1 ELSE 0 END) AS 'Other EOW'
			
	,SUM(CASE WHEN 
				(targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (worktype IN('CA','PM','RM','RQL')) 
				AND status NOT IN('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD') AND assignedownergroup IN('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP'))
		THEN 1 ELSE 0 END) AS 'Other EOM'
		
	,SUM(CASE WHEN 
				(targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND (targcompdate <= CURRENT_TIMESTAMP 
				AND (CURRENT_TIMESTAMP >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0))) AND status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') 
				AND assignedownergroup IN('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP'))
			THEN 1 ELSE 0 END) AS 'Other Risk Late'
	
	,SUM(CASE WHEN (targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)+1, 0) AND ((CURRENT_TIMESTAMP >= (DATEADD(DAY,-10,targcompdate)) 
				AND pluscfrequency IN('1','7', '14') AND pluscfrequnit IN('DAYS','MONTHS')) or ((fnlconstraint < CURRENT_TIMESTAMP) 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit IN('MONTHS')) or (fnlconstraint <= CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,36,targcompdate)) AND pluscfrequency between 5 AND 11 AND pluscfrequnit IN('MONTHS')or fnlconstraint < CURRENT_TIMESTAMP 
				AND CURRENT_TIMESTAMP > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit IN('YEARS'))) 
				And status NOT IN('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND assignedownergroup IN('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP'))
			THEN 1 ELSE 0 END) AS 'Other Risk Missed'
	
	,SUM(CASE WHEN 
				(status IN('FLAGGED')and assignedownergroup IN('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP'))
			THEN 1 ELSE 0 END) AS 'Other Flagged'
			
	,SUM(CASE WHEN 
				(status IN('MISSED')and assignedownergroup IN('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP'))
			THEN 1 ELSE 0 END) AS 'Other Missed'

FROM workorder
WHERE 
	woclass in('WORKORDER','ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	--AND targcompdate >= DATEADD(MONTH, DATEDIFF(MONTH,0,CURRENT_TIMESTAMP)-1,0) --Previous Month
;