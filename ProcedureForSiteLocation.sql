
CREATE PROCEDURE dbo.GetScope
    @scope VARCHAR(8)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT siteid, location
    FROM (VALUES
        ('ASPEX', 'ASPCS'),
        ('FWN',   'FWNCS')
    ) v(siteid, location)
    WHERE siteid = @scope;
END;
