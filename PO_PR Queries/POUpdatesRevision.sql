USE max76PRD


-- First, verify which revision should be REVISD
SELECT 
    ponum,
    revisionnum,
	historyflag,
    status,
    orderdate,
    statusdate
FROM dbo.po
WHERE ponum = '3004459894'  -- Replace with actual PO number
ORDER BY revisionnum;

-- Then update the old revision (make sure revisionnum is the OLD one, not the max), and update history flag and status date
UPDATE dbo.po
SET historyflag = 1
    WHERE ponum = '3004459894'
    AND revisionnum = 1  -- Replace X with the OLD revision number
	AND changeby = 'HICKSSH3'
    AND siteid = 'FWN';