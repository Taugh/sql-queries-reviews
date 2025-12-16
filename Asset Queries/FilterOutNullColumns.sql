DECLARE @TableName NVARCHAR(MAX) = 'a_asset';
DECLARE @AssetNum NVARCHAR(100) = '17425';
DECLARE @SiteID NVARCHAR(50) = 'FWN';
DECLARE @SQL NVARCHAR(MAX) = '';
DECLARE @ColumnName NVARCHAR(MAX);

IF OBJECT_ID('tempdb..#NonNullColumns') IS NOT NULL
    DROP TABLE #NonNullColumns;

CREATE TABLE #NonNullColumns (ColumnName NVARCHAR(MAX));

DECLARE column_cursor CURSOR FOR
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @TableName;

OPEN column_cursor;
FETCH NEXT FROM column_cursor INTO @ColumnName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @CheckSQL NVARCHAR(MAX) = 
        'IF EXISTS (
            SELECT 1 FROM ' + QUOTENAME(@TableName) + 
            ' WHERE assetnum = @AssetNum AND siteid = @SiteID AND ' + 
            QUOTENAME(@ColumnName) + ' IS NOT NULL
        )
        INSERT INTO #NonNullColumns VALUES (@ColName)';

    EXEC sp_executesql 
        @CheckSQL,
        N'@AssetNum NVARCHAR(100), @SiteID NVARCHAR(50), @ColName NVARCHAR(MAX)',
        @AssetNum = @AssetNum,
        @SiteID = @SiteID,
        @ColName = @ColumnName;

    FETCH NEXT FROM column_cursor INTO @ColumnName;
END

CLOSE column_cursor;
DEALLOCATE column_cursor;

SELECT @SQL = STRING_AGG(QUOTENAME(ColumnName), ', ')
FROM #NonNullColumns;

SET @SQL = 'SELECT ' + @SQL + ' FROM ' + QUOTENAME(@TableName) + 
           ' WHERE assetnum = @AssetNum AND siteid = @SiteID';

EXEC sp_executesql 
    @SQL,
    N'@AssetNum NVARCHAR(100), @SiteID NVARCHAR(50)',
    @AssetNum = @AssetNum,
    @SiteID = @SiteID;

DROP TABLE #NonNullColumns;

