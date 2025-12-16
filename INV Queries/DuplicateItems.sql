USE max76PRD
GO

-- locate duplicate items
SELECT itemnum AS Item
	--,modelnum AS 'Model #'
	,COUNT( modelnum) AS Count
	,COUNT(catalogcode) AS 'Count 2'
FROM dbo.inventory
WHERE itemsetid = 'IUS' AND siteid = 'FWN' AND location = 'FWNCS'
GROUP BY modelnum, itemnum
HAVING COUNT( modelnum) > 1 OR COUNT(catalogcode) > 1
--ORDER BY 'Model #';

SELECT a.itemnum
	,a.modelnum
FROM dbo.inventory AS a
	INNER JOIN (SELECT itemnum
					,modelnum
					,COUNT(catalogcode)  AS Count
				FROM dbo.inventory 
				WHERE itemsetid = 'IUS' AND siteid = 'FWN' AND location = 'FWNCS' AND status <> 'OBSOLETE'
				GROUP BY itemnum, modelnum
				HAVING COUNT(catalogcode) > 1
				)  AS b
ON a.itemnum = b.itemnum AND a.modelnum = b.modelnum
WHERE itemsetid = 'IUS' AND siteid = 'ASPEX' AND location = 'ASPEX' AND status <> 'OBSOLETE'
ORDER BY modelnum ;

SELECT itemnum
	,modelnum
	,siteid
	,COUNT(*) OVER (PARTITION BY itemnum) AS Count
FROM dbo.inventory
WHERE itemsetid = 'IUS' AND siteid = 'FWN' AND location = 'FWNCS' AND status <> 'OBSOLETE' 
ORDER BY 'Count' desc, modelnum desc;