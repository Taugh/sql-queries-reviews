USE max76PRD

/*==========================================================================================================================
Query Name: PRIORITY Weekly Summary V3
Purpose: Weekly Work Order Summary filtered by assigned owner group and categorized by status and timing.
         Calculates counts for End-Of-Week, End-Of-Month, Risk Late, Risk Missed, Flagged, and Missed WOs.
Row Grain: One row per owner group category (ProdMaint, CritSys, LCProd, ENG, PSProd, QA_QC, Other).
Assumptions:
    - Uses "targcompdate", "fnlconstraint", "pluscfrequency", and "pluscfrequnit" on "dbo.workorder" for timing/risk rules.
    - Only current work orders (historyflag = 0) and non-task records are considered.
    - Server local GETDATE()/CURRENT_TIMESTAMP semantics are acceptable for timing checks.
Parameters:
    - @StartOfYear: DATETIME - month start 12 months ago (anchor, not used in final aggregates but available)
    - @EndOfWeek: DATETIME - end of current week
    - @StartNextMonth: DATETIME - first day of next month (used to define EOM and near-term risk)
    - @TodayMidnight: DATETIME - today at 00:00 (used for inclusive day comparisons)
    - @WorkTypes, @ExcludedStatus, @OwnerGroups: in-memory table parameters used for filtering and grouping
Filters:
    - "siteid = 'FWN'"
    - "woclass IN ('WORKORDER','ACTIVITY')"
    - "historyflag = 0" and "istask = 0"
    - Work types limited to ('CA','PM','RM','RQL') via "@WorkTypes"
    - Excludes statuses: COMP, FLAGGED, MISSED, PENRVW, PENDQA, REVWD via "@ExcludedStatus" (when excluding from aggregates)
Security:
    - Read-only SELECTs from "dbo.workorder". Uses local table variables only; no writes/DDL executed.
Version Control:
    - Version: 3.0
    - Author: BRANNTR1
    - Date: 2026-01-06
Change Log:
    - 3.0 2026-01-06: Added reusable query template header and metadata; preserved original logic.
==========================================================================================================================*/

/* === Date anchors === */
DECLARE @CurrentTime     DATETIME = CURRENT_TIMESTAMP;                                        -- capture current time once
DECLARE @EndOfWeek       DATETIME = DATEADD(DAY, DATEDIFF(DAY, 0, @CurrentTime) + 7, 0);      -- end of current week
DECLARE @StartNextMonth  DATETIME = DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentTime) + 1, 0);  -- first day of next month
DECLARE @TodayMidnight   DATETIME = DATEADD(DAY, DATEDIFF(DAY, 0, @CurrentTime), 0);          -- today @ 00:00


/* === Owner group category mapping === */
DECLARE @OwnerGroups TABLE (
    category   VARCHAR(16),
    ownergroup VARCHAR(16)
);

/* === Production Maintenance === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('ProdMaint','FWNAE'),
       ('ProdMaint','FWNLC1'),
       ('ProdMaint','FWNLC2'),
       ('ProdMaint','FWNPS');

/* === Critical Systems === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('CritSys','FWNCSM'),
	   ('CritSys','FWNMET'),
	   ('CritSys','FWNWSM'),
	   ('CritSys','FWNCS'),
	   ('CritSys','FWNMNTSCH');

/* === Lens Care Production === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('LCProd','FWNLCP1'),
	   ('LCProd','FWNLCP2'),
	   ('LCProd','FWNLCP3'),
	   ('LCProd','FWNCSS'),
	   ('LCProd','FWNLCP4');

/* === Engineering === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('ENG','FWNEN2'),
	   ('ENG','FWNCAD'),
	   ('ENG','FWNPA1'),
	   ('ENG','FWNPE'),
	   ('ENG','FWNVAL'),
	   ('ENG','FWNAE'),
	   ('ENG','FWNAE2');

/* === PharmSurg Production === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('PSProd','FWNPSC'),
	   ('PSProd','FWNPSP'),
	   ('PSProd','FWNPSP1'),
	   ('PSProd','FWNPSP2'),
	   ('PSProd','FWNPSP3'),
	   ('PSProd','FWNPSP4'),
	   ('PSProd','FWNPSP5'),
	   ('PSProd','FWNPSP6'),
	   ('PSProd','FWNPSP7');

/* === Quality Assurance and Quality Control === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('QA_QC','FWNAST'),
	   ('QA_QC','FWNAST1'),
	   ('QA_QC','FWNCCM'),
	   ('QA_QC','FWNQACA'),
	   ('QA_QC','FWNQACL'),
	   ('QA_QC','FWNQACP'),
	   ('QA_QC','FWNQALO'),
	   ('QA_QC','FWNQAMI'),
	   ('QA_QC','FWNQAOP'),
	   ('QA_QC','FWNQAW'),
	   ('QA_QC','FWNQOI');

/* === All other groups === */
INSERT INTO @OwnerGroups (category, ownergroup)
VALUES ('Other','FWNCI'),
	   ('Other','FWNFMOP'),
	   ('Other','FWNHSE'),
	   ('Other','FWNMC1'),
	   ('Other','FWNITOP');


SELECT
    og.category AS [Group],

    /* Work orders due by END of current week (between today and 7 days from now) */
    SUM(CASE 
        WHEN wo.targcompdate <= @EndOfWeek 
         AND wo.targcompdate > @TodayMidnight
         AND wo.worktype IN ('CA', 'PM', 'RM', 'RQL')
         AND wo.status NOT IN ('COMP', 'FLAGGED', 'MISSED', 'PENRVW', 'PENDQA', 'REVWD')
        THEN 1 ELSE 0 
    END) AS [EOW],

    /* Work orders due exactly at END of month (first day of next month) */
    SUM(CASE 
        WHEN wo.targcompdate = @StartNextMonth
         AND wo.worktype IN ('CA', 'PM', 'RM', 'RQL')
         AND wo.status NOT IN ('COMP', 'FLAGGED', 'MISSED', 'PENRVW', 'PENDQA', 'REVWD')
        THEN 1 ELSE 0 
    END) AS [EOM],

    /* Work orders at risk of being late */
    SUM(CASE 
        WHEN wo.targcompdate <> wo.fnlconstraint
         AND wo.targcompdate <= @StartNextMonth
         AND wo.targcompdate <= @CurrentTime
         AND @CurrentTime >= DATEADD(DAY, DATEDIFF(DAY, 0, wo.fnlconstraint) - 10, 0)
         AND wo.status NOT IN ('COMP', 'CORRTD', 'MISSED', 'PENRVW', 'PENDQA', 'FLAGGED', 'REVWD')
        THEN 1 ELSE 0
    END) AS [Risk Late],

    /* Work orders at risk of being missed based on frequency and timing */
    SUM(CASE 
        WHEN wo.targcompdate <= @StartNextMonth
         AND (
            (@CurrentTime >= DATEADD(DAY, -10, wo.targcompdate) 
                AND wo.pluscfrequency IN ('1', '7', '14') AND wo.pluscfrequnit IN ('DAYS', 'MONTHS'))
            OR (wo.fnlconstraint < @CurrentTime 
                AND @CurrentTime > DATEADD(DAY, 8, wo.targcompdate) 
                AND wo.pluscfrequency BETWEEN 2 AND 5 AND wo.pluscfrequnit IN ('MONTHS'))
            OR (wo.fnlconstraint <= @CurrentTime 
                AND @CurrentTime > DATEADD(DAY, 36, wo.targcompdate) 
                AND wo.pluscfrequency BETWEEN 5 AND 11 AND wo.pluscfrequnit IN ('MONTHS'))
            OR (wo.fnlconstraint < @CurrentTime 
                AND @CurrentTime > DATEADD(DAY, 50, wo.targcompdate) 
                AND wo.pluscfrequency >= 1 AND wo.pluscfrequnit IN ('YEARS'))
        )
         AND wo.status NOT IN ('COMP', 'CORRTD', 'MISSED', 'PENRVW', 'PENDQA', 'FLAGGED', 'REVWD')
        THEN 1 ELSE 0
    END) AS [Risk Missed],

    /* Flagged & Missed - no status exclusions for these */
    SUM(CASE WHEN wo.status = 'FLAGGED' THEN 1 ELSE 0 END) AS [Flagged],
    SUM(CASE WHEN wo.status = 'MISSED'  THEN 1 ELSE 0 END) AS [Missed]

FROM dbo.workorder AS wo
INNER JOIN @OwnerGroups AS og
        ON wo.assignedownergroup = og.ownergroup
WHERE wo.woclass IN ('WORKORDER','ACTIVITY')
  AND wo.historyflag = 0
  AND wo.istask = 0
  AND wo.siteid = 'FWN'
GROUP BY og.category
ORDER BY og.category;
