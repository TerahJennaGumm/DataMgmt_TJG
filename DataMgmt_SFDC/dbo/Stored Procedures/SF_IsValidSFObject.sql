
CREATE PROCEDURE [dbo].[SF_IsValidSFObject]
	@table_server sysname,
	@table_name sysname

AS
-- Parameters: @table_name             - Salesforce object to validate (i.e. Account)

-- Return Code: 0 if not valid
--				1 if valid

Begin
	declare @sql nvarchar(max)
	declare @objectname nvarchar(100)
	declare @parmlist nvarchar(4000)
	select @sql = 'Select @NAMEOUT = Name from '
	select @sql = @sql + @table_server + '...sys_sfobjects' + ' where' + ' Name = ' + '''' + @table_name + ''''
	select @parmlist = '@NAMEOUT nvarchar(100) OUTPUT'
	exec sp_executesql @sql,@parmlist, @NAMEOUT=@objectname OUTPUT
	If @objectname is Null
		RETURN 0
	else
		RETURN 1
END

