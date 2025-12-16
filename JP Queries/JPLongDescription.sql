USE max76PRD
GO

--Returns Job Plan description WITH long description
SELECT j.jpnum AS 'Job Plan #'
	,j.pluscjprevnum AS 'Revision #'
	,j.siteid
	,jptask AS 'Task #'
	,description AS 'Description'
	,jobtaskid
	,l.ldtext AS 'Long Description'
	,l.ldownertable
FROM dbo.jobtask AS j
	INNER JOIN
			  (SELECT jpnum
				,MAX(pluscjprevnum) AS MaxRev
			   FROM dbo.jobtask
			   WHERE siteid = 'FWN' --AND jpnum = 'JP0548'
			   GROUP BY jpnum
			   ) AS k
ON j.jpnum = k.jpnum AND j.pluscjprevnum = k.MaxRev
	LEFT JOIN
			(SELECT ldkey
				,ldownertable
				,ldtext
			FROM dbo.longdescription
			WHERE ldownertable = 'JOBTASK'
			) AS l
ON j.jobtaskid = l.ldkey
WHERE j.siteid = 'FWN' AND j.pluscjprevnum = k.MaxRev AND ldtext like '%CM%'
ORDER BY 'Task #';
