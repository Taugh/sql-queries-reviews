USE max76PRD
GO

--Quiries for Weekly Summary Reports

--Production Maintenance
SELECT COUNT(wonum) AS 'ProdMain Due Next Week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) AND targcompdate >  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+0, 0) 
	AND (worktype in ('CA','PM','RM','RQL')) AND assignedownergroup in ('FWNLC1','FWNLC2','FWNPS','FWNMOS') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNLC1','FWNLC2','FWNPS','FWNMOS') AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

SELECT COUNT(wonum) AS 'At Risk Late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLC1','FWNLC2','FWNPS','FWNMOS') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) 
	AND (targcompdate <= GETDATE() AND (GETDATE() >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0))));

SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLC1','FWNLC2','FWNPS','FWNMOS') AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) 
	AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) 
	OR ((fnlconstraint < GETDATE()) AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 
	AND pluscfrequnit in ('MONTHS')) OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) 
	AND pluscfrequency between 5 AND 11 AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() 
	AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLC1','FWNLC2','FWNPS','FWNMOS') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLC1','FWNLC2','FWNPS','FWNMOS') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

--Critical System Maintenance
SELECT COUNT(wonum) AS 'CSMain Due Next Week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) AND targcompdate >  DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0, 0) 
	AND (worktype in ('CA','PM','RM','RQL')) AND assignedownergroup in ('FWNCSM','FWNMET','FWNWSM') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNCSM','FWNMET','FWNWSM') AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

SELECT COUNT(wonum) AS 'At Risk Late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNCSM','FWNMET','FWNWSM') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) 
	AND (targcompdate <= GETDATE() AND (GETDATE() >= DATEADD(DAY,DATEDIFF(DAY,0,fnlconstraint)-10, 0))));

SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNCSM','FWNMET','FWNWSM') AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) 
	AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) 
	OR ((fnlconstraint < GETDATE()) AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 
	AND pluscfrequnit in ('MONTHS')) OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) 
	AND pluscfrequency between 5 AND 11 AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() 
	AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNCSM','FWNMET','FWNWSM') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNCSM','FWNMET','FWNWSM') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

--LC Production
--Due next week
SELECT COUNT(wonum) AS 'LCProd Due Next Week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) AND targcompdate >  DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0, 0) 
	AND (worktype in ('CA','PM','RM','RQL')) AND assignedownergroup in ('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

--Due by END of month
SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS') AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

--At risk of being late (for WO within ten days of target due date)
SELECT COUNT(wonum) AS 'At Risk late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) 
	AND (targcompdate <= GETDATE() AND (GETDATE() >= DATEADD(DAY,-10,fnlconstraint))));

-- At risk of being missed (for WO within ten days of the finish no later date)
SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS') AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) 
	AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) 
	OR ((fnlconstraint < GETDATE()) AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 
	AND pluscfrequnit in ('MONTHS')) OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) 
	AND pluscfrequency between 5 AND 11 AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() 
	AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNLCP1','FWNLCP2','FWNLCP3','FWNCSS') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

--Engineering
--Due next week
SELECT COUNT(wonum) AS 'ENG Due Next Week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) AND targcompdate >  DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0, 0) 
	AND (worktype in ('CA','PM','RM','RQL')) AND assignedownergroup in ('FWNAE','FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

--Due by END of month
SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNAE','FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRVW','PENDQA','REVWD'));

--At risk of being late (for WO within ten days of target due date)
SELECT COUNT(wonum) AS 'At Risk Late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAE','FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) 
	AND (targcompdate <= GETDATE() AND (GETDATE() >= DATEADD(DAY,-10,fnlconstraint))));

-- At risk of being missed (for WO within ten days of the finish no later date)
SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAE','FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL') AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) 
	AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) 
	OR ((fnlconstraint < GETDATE()) AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 
	AND pluscfrequnit in ('MONTHS')) OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) 
	AND pluscfrequency between 5 AND 11 AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() 
	AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAE','FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAE','FWNEN2','FWNCAD','FWNPA1','FWNPE','FWNVAL') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

--PS Production
--Due next week
SELECT COUNT(wonum) AS 'PSProd Due Next Week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRWD','PENDQA','REVWD') AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) 
	AND targcompdate >  DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0, 0) AND (targcompdate <> GETDATE()) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6'));

--Due by END of month
SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRWD','PENDQA','REVWD'));

--At risk of being late (for WO within ten days of target due date)
SELECT COUNT(wonum) AS 'At Risk Late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6') 
	AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' AND targcompdate <> fnlconstraint 
	AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (targcompdate <= GETDATE() 
	AND (GETDATE() >= DATEADD(DAY,-10,fnlconstraint))));

-- At risk of being missed (for WO within ten days of the finish no later date)
SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6') AND historyflag = 0 AND istask = 0 
	AND siteid = 'FWN' AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) 
	AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) 
	OR ((fnlconstraint < GETDATE()) AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 
	AND pluscfrequnit in ('MONTHS')) OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) 
	AND pluscfrequency between 5 AND 11 AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() 
	AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in  ('FWNPSC','FWNPSP','FWNPSP1','FWNPSP2','FWNPSP3','FWNPSP4','FWNPSP5','FWNPSP6') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

--QA/QC
--Due next week
SELECT COUNT(wonum) AS 'QA/QC Due Next Week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) AND targcompdate > GETDATE() AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNAST','FWNAST1','FWNCCM','FWNMICR1', 'FWNMICR2','FWNQACA','FWNQCAST','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRWD','PENDQA','REVWD'));

--Due by END of month
SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNAST','FWNAST1','FWNCCM','FWNMICR1', 'FWNMICR2','FWNQACA','FWNQCAST','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRWD','PENDQA','REVWD'));

--At risk of being late (for WO within ten days of target due date)
SELECT COUNT(wonum) AS 'At Risk Late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAST','FWNAST1','FWNCCM','FWNMICR1', 'FWNMICR2','FWNQACA','FWNQCAST','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI')
	AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' AND targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) 
	AND (targcompdate <= GETDATE() AND (GETDATE() >= DATEADD(DAY,-10,fnlconstraint))));

-- At risk of being missed (for WO within ten days of the finish no later date)
SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAST','FWNAST1','FWNCCM','FWNMICR1', 'FWNMICR2','FWNQACA','FWNQCAST','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI')
	AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) 
	AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) OR ((fnlconstraint < GETDATE()) 
	AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit in ('MONTHS')) 
	OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) AND pluscfrequency between 5 AND 11 
	AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNAST','FWNAST1','FWNCCM','FWNMICR1', 'FWNMICR2','FWNQACA','FWNQCAST','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI')
	AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in  ('FWNAST','FWNAST1','FWNCCM','FWNMICR1', 'FWNMICR2','FWNQACA','FWNQCAST','FWNQACL','FWNQACP','FWNQALO','FWNQAMI','FWNQAOP','FWNQAW','FWNQOI')
	AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

--Other
--Due next week
SELECT COUNT(wonum) AS 'Other Due next week'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <=  DATEADD(DAY,DATEDIFF(DAY,0,GETDATE())+7, 0) AND targcompdate >  DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+0, 0) 
	AND (worktype in ('CA','PM','RM','RQL')) AND assignedownergroup in ('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP') 
	AND status NOT in ('COMP','FLAGGED','MISSED','PENRWD','PENDQA','REVWD'));

--Due by END of month
SELECT COUNT(wonum) AS 'Due EOM'
FROM dbo.workorder
WHERE ((woclass = 'WORKORDER' OR woclass = 'ACTIVITY') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate = DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) AND (worktype in ('CA','PM','RM','RQL')) 
	AND assignedownergroup in ('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP') 
	AND status NOT in ('COMP','MISSED','PENRVW','PENDQA','FLAGGED','REVWD'));

--At risk of being late (for WO within ten days of target due date)
SELECT COUNT(wonum) AS 'At Risk Late'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP')  AND historyflag = 0 AND istask = 0 AND siteid = 'FWN' 
	AND targcompdate <> fnlconstraint AND targcompdate <= DATEADD(MONTH,DATEDIFF(MONTH,0,GETDATE())+1, 0) 
	AND (targcompdate < GETDATE() AND (GETDATE() >= DATEADD(DAY,-10,fnlconstraint))));

-- At risk of being missed (for WO within ten days of the finish no later date)
SELECT COUNT(wonum) AS 'At Risk Missed'
FROM dbo.workorder
WHERE (status NOT in ('COMP','CORRTD','MISSED','PENRVW','PENDQA','FLAGGED','REVWD') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in ('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN'
	AND targcompdate <= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE())+1, 0)) AND ((GETDATE() >= (DATEADD(DAY,-10,targcompdate)) 
	AND pluscfrequency in ('1','7', '14') AND pluscfrequnit in ('DAYS','MONTHS')) OR ((fnlconstraint < GETDATE()) 
	AND GETDATE() > (DATEADD(DAY,8,targcompdate)) AND pluscfrequency between 2 AND 5 AND pluscfrequnit in ('MONTHS')) 
	OR (fnlconstraint <= GETDATE() AND GETDATE() > (DATEADD(DAY,36,targcompdate)) AND pluscfrequency between 5 AND 11 
	AND pluscfrequnit in ('MONTHS') OR fnlconstraint < GETDATE() AND GETDATE() > (DATEADD(DAY,50,targcompdate)) AND pluscfrequency >= 1 AND pluscfrequnit in ('YEARS')));

SELECT COUNT(wonum) AS 'Flagged'
FROM dbo.workorder
WHERE (status in ('FLAGGED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in  ('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');

SELECT COUNT(wonum) AS 'Missed'
FROM dbo.workorder
WHERE (status in ('MISSED') AND woclass in ('WORKORDER','ACTIVITY') 
	AND assignedownergroup in  ('FWNCI','FWNFMOP','FWNHSE','FWNMC1','FWNITOP') AND historyflag = 0 AND istask = 0 AND siteid = 'FWN');