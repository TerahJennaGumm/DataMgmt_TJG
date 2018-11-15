

CREATE procedure [dbo].[SFDC_RefreshObjectFormulaData]
	@linked_server varchar(128) --= 'salesforce_sandbox'
	,@source_object varchar(128) --= 'dbo.case'
	,@target_table varchar(128) --= 'dbo.case'
as
declare
	@table_quoted varchar(128)
	,@table varchar(128)
	,@table_schema varchar(128)
	,@table_formula_fields varchar(128)
	,@col_list varchar(max)
	,@col_list_update varchar(max)
	,@stmt nvarchar(max)
	,@now varchar(64) = convert(varchar(64), getdate(), 120)
	,@start_ts varchar(64) = convert(varchar(64), getdate(), 120)
	
begin
	set nocount on;
	set @now = convert(varchar(64), getdate(), 120);
	raiserror('****	%s	Refreshing table formula data for %s: Starting', 10, 1, @now, @target_table) with nowait;
	
	-----------------------------------------------
	--#region: Ensure sys_sffields is up to date --
	-----------------------------------------------
	if (exists(select top 1 1 from sys.tables where object_id = object_id('dbo.sys_sffields') and create_date < getdate() - .25))
	begin
		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Detected dbo.sys_sffields has not been updated in the past 24 hours: Updating', 10, 1, @now) with nowait;
		
		if (object_id('dbo.sys_sffields_tmp') is not null)
			drop table dbo.sys_sffields_tmp;

		select * into dbo.sys_sffields_tmp from dbo.sys_sffields where 1=2;

		insert into dbo.sys_sffields_tmp
		exec('select * from ' + @linked_server + '...sys_sffields');

		alter table dbo.sys_sffields_tmp add constraint pk_sys_sffields_tmp primary key (ObjectName, Name);
		
		drop table dbo.sys_sffields;
		exec dbo.sp_rename 'dbo.sys_sffields_tmp', 'sys_sffields';
		exec dbo.sp_rename 'pk_sys_sffields_tmp', 'pk_sys_sffields';

		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Detected dbo.sys_sffields has not been updated in the past 24 hours: Finished', 10, 1, @now) with nowait;
		
	end
	--#endregion --

	-----------------------------------------------
	--#region: Ensure sys_sfobjects is up to date --
	-----------------------------------------------
	if (exists(select top 1 1 from sys.tables where object_id = object_id('dbo.sys_sfobjects') and create_date < getdate() - .25))
	begin
		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Detected dbo.sys_sfobjects has not been updated in the past 24 hours: Updating', 10, 1, @now) with nowait;
		
		if (object_id('dbo.sys_sfobjects_tmp') is not null)
			drop table dbo.sys_sfobjects_tmp;

		select * into dbo.sys_sfobjects_tmp from dbo.sys_sfobjects where 1=2;

		insert into dbo.sys_sfobjects_tmp
		exec('select * from ' + @linked_server + '...sys_sfobjects');

		alter table dbo.sys_sfobjects_tmp add constraint pk_sys_sfobjects_tmp primary key (Name);
		
		drop table dbo.sys_sfobjects;
		exec dbo.sp_rename 'dbo.sys_sfobjects_tmp', 'sys_sfobjects';
		exec dbo.sp_rename 'pk_sys_sfobjects_tmp', 'pk_sys_sfobjects';

		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Detected dbo.sys_sfobjects has not been updated in the past 24 hours: Finished', 10, 1, @now) with nowait;
		
	end
	--#endregion --

	-------------------------------------------
	--#region: Initialization and Validation --
	-------------------------------------------
	-- Get Target Table name without adornment --
	select
		@table = name
		,@table_schema = schema_name(schema_id)
		,@table_quoted = quotename(schema_name(schema_id)) + '.' + quotename(name)
	from sys.tables
	where object_id = object_id(@target_table);

	-- Get Formula Fields table name --
	set @table_formula_fields = '[dbo].' + quotename(@table + '_' + cast(newid() as varchar(36)));

	set @now = convert(varchar(64), getdate(), 120);
	raiserror('%s	Linked Server Name: %s', 10, 1, @now, @linked_server) with nowait;
	raiserror('%s	SFDC Object Name: %s', 10, 1, @now, @source_object) with nowait;
	raiserror('%s	Target Table Name: %s', 10, 1, @now, @table) with nowait;
	raiserror('%s	Quoted Target Table Schema: %s', 10, 1, @now, @table_schema) with nowait;
	raiserror('%s	Quoted Target Table Name: %s', 10, 1, @now, @table_quoted) with nowait;
	raiserror('%s	Formula Fields Table Name: %s', 10, 1, @now, @table_formula_fields) with nowait;

	-- Check for Id on table --
	if (not exists(select top 1 1 from sys.columns where object_id = object_id(@table) and name = 'Id'))
	begin
		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Local table %s does not contain column Id', 16, 1, @now) with nowait;
		return;
	end;
	--#endregion --

	--------------------------------
	--#region: Refresh Table Data --
	--------------------------------
	begin try
		set @start_ts = convert(char(19), getutcdate(), 126) + 'Z';
		

		--#region: Formula Fields Refresh
		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Refreshing Formulas: Starting', 10, 1, @now) with nowait;

		--reusing our variables from before - bad practice ;)
		select
		@col_list = stuff((
				select
					',' + c.name
				from sys.tables t
					join sys.columns c
						on t.object_id = c.object_id
					join dbo.sys_sffields sf
						on t.name = sf.ObjectName
						and c.name = sf.Name
				where t.object_id = object_id(@table)
					and (sf.Calculated = 'true'
						or c.name in ('Id')
					)
				order by c.column_id
				for xml path('')
			),1,1,''
		);

		select
		@col_list_update = stuff((
				select
					',t.' + c.name + ' = ' + 's.' + c.name
				from sys.tables t
					join sys.columns c
						on t.object_id = c.object_id
					join dbo.sys_sffields sf
						on t.name = sf.ObjectName
						and c.name = sf.Name
				where t.object_id = object_id(@table)
					and sf.calculated = 'true'
					and c.name not in ('Id')
				order by c.column_id
				for xml path('')
			),1,1,''
		);

			

		set @stmt = 'select * into ' + @table_formula_fields + ' from openquery(' + @linked_server + ', ''select ' + @col_list + ' from ' + @source_object + ''') a';
		--print @stmt;
		exec(@stmt);

			
		set @stmt = 'update t set ' + @col_list_update + ' from ' + @table_quoted + ' t join ' + @table_formula_fields + ' s on t.id = s.id;'
		--print @stmt;
		exec(@stmt);

		set @now = convert(varchar(64), getdate(), 120);
		raiserror('%s	Refreshing Formulas: Finished', 10, 1, @now) with nowait;
		--#endregion

		--#region: Clean up temp table
		set @stmt = '
		if (exists(select top 1 1 from sys.tables where object_id = object_id(''' + @table_formula_fields + ''')))
			drop table ' + @table_formula_fields + ';';

	
		exec(@stmt);
		--#endregion
		--#region: Mark Last Update date in extended properties
		if exists(select top 1 1 from sys.extended_properties where name = 'SFDC_FormulaLastRefreshDateTime' and class_desc = 'OBJECT_OR_COLUMN' and major_id = object_id(@table_quoted))
		begin
			exec dbo.sp_updateextendedproperty @name='SFDC_FormulaLastRefreshDateTime', @value=@start_ts
				,@level0type = N'Schema', @level0name = @table_schema
				,@level1type = N'Table',  @level1name = @table;
		end
		else
		begin
			exec dbo.sp_addextendedproperty @name='SFDC_FormulaLastRefreshDateTime', @value=@start_ts
				,@level0type = N'Schema', @level0name = @table_schema
				,@level1type = N'Table',  @level1name = @table;
		end
		--#endregion
		--#region: Mark Last Update date in SFDC_SyncSchedule
		IF EXISTS ( SELECT TOP 1 * from [dbo].sfdc_syncschedule where TblName = @table_quoted )
		  begin
			 UPDATE  dbo.SFDC_SyncSchedule
				SET     lastformularefresh = CONVERT(VARCHAR(64), CAST(@start_ts AS DATETIMEOFFSET), 127)
				WHERE   TblName = @table_quoted 
		  end
		  else
		  begin
			 INSERT  INTO dbo.SFDC_SyncSchedule(TblName ,lastformularefresh)
				SELECT  @table_quoted , CONVERT(VARCHAR(64), CAST(@start_ts AS DATETIMEOFFSET), 127)
		  end


		--#endregion

	end try
	begin catch
		declare @err_num varchar(8)
			,@err_sev varchar(8)
			,@err_state varchar(8)
			,@err_proc varchar(128)
			,@err_line varchar(8)
			,@err_msg varchar(2048);
		SELECT
			 @err_num = ERROR_NUMBER() 
			,@err_sev = ERROR_SEVERITY()
			,@err_state = ERROR_STATE()
			,@err_proc = ERROR_PROCEDURE()
			,@err_line = ERROR_LINE() 
			,@err_msg = ERROR_MESSAGE();
		
		-- Reraise the error and get out!
		raiserror('Error in procedure %s on line %s: %s.
		Error Number: %s, Severity: %s, State: %s', 16, 10,
			@err_proc
			,@err_line
			,@err_msg
			,@err_num
			,@err_sev
			,@err_state
			);
		return;
	end catch

	set @now = convert(varchar(64), getdate(), 120);
	raiserror('****	%s	Refreshing table %s data: Finished', 10, 1, @now, @table) with nowait;
	--#endregion --
end;

