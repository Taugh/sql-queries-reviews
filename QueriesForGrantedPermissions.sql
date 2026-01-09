
-- Who am I in this DB?
SELECT USER_NAME() AS DbUser;

-- Am I in db_owner OR db_ddladmin?
SELECT 
    'db_owner' AS role, IS_MEMBER('db_owner')   AS is_member
UNION ALL
SELECT 
    'db_ddladmin' AS role, IS_MEMBER('db_ddladmin') AS is_member;
-- Show ALL database roles I belong to (comprehensive check)
SELECT 
    role_name,
    CASE WHEN is_member = 1 THEN 'YES' ELSE 'NO' END AS member_status
FROM (
    SELECT 'db_owner' AS role_name, IS_MEMBER('db_owner') AS is_member
    UNION ALL SELECT 'db_accessadmin', IS_MEMBER('db_accessadmin')
    UNION ALL SELECT 'db_backupoperator', IS_MEMBER('db_backupoperator')
    UNION ALL SELECT 'db_datareader', IS_MEMBER('db_datareader')
    UNION ALL SELECT 'db_datawriter', IS_MEMBER('db_datawriter')
    UNION ALL SELECT 'db_ddladmin', IS_MEMBER('db_ddladmin')
    UNION ALL SELECT 'db_denydatareader', IS_MEMBER('db_denydatareader')
    UNION ALL SELECT 'db_denydatawriter', IS_MEMBER('db_denydatawriter')
    UNION ALL SELECT 'db_securityadmin', IS_MEMBER('db_securityadmin')
) AS roles
WHERE is_member = 1 OR is_member IS NULL
ORDER BY role_name;

-- Check permissions on a specific table (change 'sparepart' to any table name)
DECLARE @TableName NVARCHAR(128) = 'sparepart';

SELECT 
    OBJECT_NAME(major_id) AS table_name,
    USER_NAME(grantee_principal_id) AS grantee,
    permission_name,
    state_desc  -- GRANT, DENY, or REVOKE
FROM sys.database_permissions
WHERE major_id = OBJECT_ID(@TableName)
    AND class_desc = 'OBJECT_OR_COLUMN'
ORDER BY state_desc, permission_name;

-- Check for DENY permissions on current user or roles
SELECT 
    USER_NAME(grantee_principal_id) AS grantee,
    OBJECT_NAME(major_id) AS object_name,
    permission_name,
    state_desc,
    class_desc
FROM sys.database_permissions
WHERE grantee_principal_id IN (
    USER_ID(),  -- Current user
    USER_ID('db_datawriter'),
    USER_ID('db_datareader')
)
    AND state_desc = 'DENY'
ORDER BY object_name, permission_name;

-- Check effective permissions on sparepart table
SELECT 
    permission_name,
    CASE 
        WHEN HAS_PERMS_BY_NAME('dbo.sparepart', 'OBJECT', permission_name) = 1 
        THEN 'YES' 
        ELSE 'NO' 
    END AS has_permission
FROM (
    SELECT 'SELECT' AS permission_name
    UNION ALL SELECT 'INSERT'
    UNION ALL SELECT 'UPDATE'
    UNION ALL SELECT 'DELETE'
) AS perms
ORDER BY permission_name;

-- Check for triggers on sparepart table
SELECT 
    t.name AS trigger_name,
    t.type_desc,
    OBJECT_DEFINITION(t.object_id) AS trigger_definition
FROM sys.triggers t
WHERE parent_id = OBJECT_ID('dbo.sparepart');

-- Check for row-level security policies
SELECT 
    p.name AS policy_name,
    t.name AS table_name,
    p.is_enabled
FROM sys.security_policies p
INNER JOIN sys.security_predicates sp ON p.object_id = sp.object_id
INNER JOIN sys.tables t ON sp.target_object_id = t.object_id
WHERE t.name = 'sparepart';

-- Confirm the schema you intend to use
SELECT s.name AS schema_name
FROM sys.schemas s
ORDER BY s.name;
