USE max76PRD
GO


SELECT it.itemnum AS 'ITEM'
	,it.description AS 'Description'
	,it.status AS 'Status'
	,it.commoditygroup AS 'Commodity Group'
	,it.commodity AS 'Commodity Code'
	,iv.siteid AS 'Site'
	,iv.location AS 'Location'
	,issue1yrago AS 'Last Year Usage'
	,issue2yrago AS 'Usage 2YRs Ago'
	,issue3yrago AS 'Usage 3YRs Ago'
FROM dbo.item AS it
	INNER JOIN dbo.inventory AS iv
ON (it.itemnum = iv.itemnum AND it.itemsetid = iv.itemsetid)
WHERE it.itemsetid = 'IUS' AND it.status != 'OBSOLETE' AND (UPPER(description) like '%GREASE%' OR UPPER(description) like '%OIL%' OR UPPER(description) like '%ADHESIVE%'
	OR UPPER(description) like '%TAPE%' OR UPPER(description) like '%GLASSES%'  OR UPPER(description) like '%GLOVES%' OR UPPER(description) like '%BAGS%' OR UPPER(description) like '%BATTERY%'
	OR UPPER(description) like '%BLADE%' OR UPPER(description) like '%FLUID%' OR UPPER(description) like '%FOAM%' OR UPPER(description) like '%CABLE%' OR UPPER(description) like '%TIES%') 
	AND it.us2_controlled = 0 AND iv.gmpcritical = 0 AND iv.siteid = 'FWN' AND iv.location = 'FWNCS'


SELECT i.itemnum AS 'Item'
	,t.description AS 'Description'
	,b.location AS 'Storeroom'
	,i.status AS 'Status'
	,b.curbal AS Balance
	,i.lastissuedate AS 'Last Issued'
	,c.lastcost AS 'Last Cost'
FROM dbo.invbalances AS b
	INNER JOIN dbo.inventory AS i 
ON (b.itemnum = i.itemnum AND b.siteid = i.siteid)
	LEFT JOIN dbo.item AS t 
ON (i.itemnum = t.itemnum AND i.itemsetid = t.itemsetid)
	INNER JOIN dbo.invcost AS c 
ON (t.itemnum = c.itemnum)
WHERE b.siteid = 'FWN' AND i.status <> 'OBSOLETE' AND b.itemnum in ('100871','101083','101086','101087','101134','101470','101471','101592','101619','101969','102045','102046','102379','102380','102430','102567',
	'102616','102760','103026','103174','103242','103339','103658','103752','103753','103770','104210','104326','104549','104803','104884','104885','104886','104890','105370','105570',
	'105972','105989','106241','106551','106566','106628','107605','107626','108053','108054','108055','108056','108057','108226','108816','109203','109221','109271','109421','109767',
	'109811','109933','109937','109938','109966','110008','110270','111009','111048','111124','111154','112315','112874','113382','115973','116076','117723','117789','117790','117966','117990',
	'118933','119226','119282','119478','119760','119778','119780','119781','119782','119783','119784','119785','119786','119863','119864','119889','119890','119891','119892','119893','120290',
	'122079','122080','122121','122122','122123','122258','122259','122260','122261','122262','122263','122705','122709','122861','122862','123049','123121','123123','123128','123137','500003',
	'500005','500007','500085','500087','500100','500102','500103','500104','500112','500113','500159','500189','500202','500213','500231','500232','500233','500238','500337','500349','500350',
	'500351','500366','500368','500369','500384','500412','500413','500414','500415','500417','500418','500419','500438','500459','500460','500461','500462','500508','500575','500584','500656',
	'500657','500669','500707','500708','500713','500827','500828','500829','500830','500831','500832','500833','500841','500861','500862','500864','500870','500888','500893','500894','500916',
	'500949','500950','500951','500984','500985','501126','501128','501129','501130','501174','10027661','10028905','10028941','10029337','10029338','10029339','10029342','10029343','10029344',
	'10029696','10029920','10029966','10030137','10030622','10030694','10031021','10031022','10031575','10031576','10033519','101087B','101087Y','109203A','500002R')
