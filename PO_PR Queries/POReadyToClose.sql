USE max76PRD

/******************************************************************************************
Query Name       : POReadyToClose.sql
File Path        : C:\Users\BRANNTR1\OneDrive - Alcon\SQL Server Management Studio\PO_PR Queries/POReadyToClose.sql
Repository       : https://github.com/Taugh/sql-queries-reviews/tree/main/PO_PR%20Queries/POReadyToClose.sql
Author           : Troy Brannon
Date Created     : 2025-09-05 
Version          : 1.0 

Purpose          : Identify completed purchase orders at selected sites that have not had 
                   a receipt transaction in the last 5 days. Ensures only approved and 
                   non-canceled revisions are included.

Row Grain        : One row per unique ponum per siteid.

Assumptions      : 
                   - Only POs with status 'APPR' and receipts marked 'COMPLETE' are included.
                   - Latest revision is determined by max(revisionnum) excluding canceled POs.
                   - Last receipt date is pulled from both matrectrans and servrectrans tables.
                   - If no receipt exists, current timestamp is used as fallback.

Parameters       : 
                   - None currently parameterized; siteid and orgid are hardcoded.

Filters          : 
                   - orgid = 'US'
                   - siteid IN ('ASPEX', 'FWN')
                   - receipts = 'COMPLETE'
                   - status = 'APPR' (via synonymdomain)
                   - revisionnum = latest non-canceled revision
                   - Last receipt date is at least 5 days old

Security         : No sensitive data exposed. Ensure access to po, matrectrans, servrectrans, 
                   and synonymdomain tables is properly controlled.

Version Control  : Stored in GitHub repository 'sql-queries-reviews'
                   Link: https://github.com/Taugh/sql-queries-reviews/tree/main/PO_PR%20Queries/POReadyToClose.sql
                   Branch: main
                   Last Reviewed: 2025-09-05 by Troy Brannon

Change Log       : 
                   - 2025-09-05: Refactored for clarity, modularity, and maintainability.
******************************************************************************************/


-- Retrieve completed POs with no receipt activity in the last 5 days

SELECT 
    po.ponum,
    po.status,
    po.siteid,
    po.receipts
FROM po
WHERE 
    po.orgid = 'US'
    AND po.siteid IN ('ASPEX', 'FWN')
    AND po.receipts = 'COMPLETE'
    AND po.status IN (
        SELECT value 
        FROM synonymdomain 
        WHERE domainid = 'POSTATUS' AND maxvalue = 'APPR'
    )
    AND po.revisionnum = (
        SELECT MAX(po2.revisionnum)
        FROM po AS po2
        WHERE 
            po2.siteid = po.siteid 
            AND po2.ponum = po.ponum
            AND po2.status NOT IN (
                SELECT value 
                FROM synonymdomain 
                WHERE domainid = 'POSTATUS' AND maxvalue = 'CAN'
            )
    )
    AND DATEDIFF(
        DAY,
        COALESCE(
            (
                SELECT MAX(transdate)
                FROM (
                    SELECT transdate 
                    FROM matrectrans 
                    WHERE issuetype = 'RECEIPT' AND status = 'COMP' 
                        AND siteid = po.siteid AND ponum = po.ponum
                    UNION ALL
                    SELECT transdate 
                    FROM servrectrans 
                    WHERE issuetype = 'RECEIPT' AND status = 'COMP' 
                        AND siteid = po.siteid AND ponum = po.ponum
                ) AS txn
            ),
            CURRENT_TIMESTAMP
        ),
        CURRENT_TIMESTAMP
    ) >= 5;
