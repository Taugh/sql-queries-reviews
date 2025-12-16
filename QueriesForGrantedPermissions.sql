
-- Who am I in this DB?
SELECT USER_NAME() AS DbUser;

-- Am I in db_owner OR db_ddladmin?
SELECT 
    'db_owner'   AS role, IS_MEMBER('db_owner')   AS is_member
UNION ALL
SELECT 
    'db_ddladmin' AS role, IS_MEMBER('db_ddladmin') AS is_member;

-- Confirm the schema you intend to use
SELECT s.name AS schema_name
FROM sys.schemas s
ORDER BY s.name;
