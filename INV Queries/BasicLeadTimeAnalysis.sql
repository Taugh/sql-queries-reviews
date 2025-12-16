USE max76PRD

SELECT 
    poline.itemnum,
    poline.siteid,
    po.vendor,
    AVG(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS avg_lead_time_days,
    MIN(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS min_lead_time_days,
    MAX(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS max_lead_time_days,
    STDEV(DATEDIFF(DAY, po.orderdate, mr.actualdate)) AS lead_time_std_dev,
    COUNT(*) AS sample_count
FROM dbo.poline
INNER JOIN dbo.po ON poline.ponum = po.ponum AND poline.siteid = po.siteid
INNER JOIN dbo.matrectrans mr 
    ON poline.ponum = mr.ponum AND poline.polinenum = mr.polinenum
    AND poline.itemnum = mr.itemnum
WHERE po.status = 'CLOSE' AND po.siteid = 'FWN'
  AND  mr.actualdate >= DATEADD(MONTH, -24, GETDATE())  -- Last 12 months
GROUP BY poline.itemnum, poline.siteid, po.vendor
HAVING COUNT(*) >= 11  -- At least 3 receipts for meaningful average
ORDER BY poline.itemnum