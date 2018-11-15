

CREATE PROCEDURE [dbo].[SFDC_RefreshObjectData]
    @linked_server VARCHAR(128) --= 'salesforce_sandbox'
    ,
    @source_object VARCHAR(128) --= 'dbo.case'
    ,
    @target_table VARCHAR(128) --= 'dbo.case'
    ,
    @refresh_date DATETIME = NULL ,
    @refresh_formulas BIT = 0 ,
    @clean_up_temps BIT = 1
    WITH RECOMPILE
AS
    DECLARE @table_quoted VARCHAR(128) ,
        @table VARCHAR(128) ,
        @table_schema VARCHAR(128) ,
        @table_temp VARCHAR(128) ,
        @table2_temp VARCHAR(128) ,
        @table_hist VARCHAR(128) ,
        @col_list VARCHAR(MAX) ,
        @col_list1 VARCHAR(MAX) ,
        @col_list2 VARCHAR(MAX) ,
        @col_list_update VARCHAR(MAX) ,
        @timestamp_col VARCHAR(128) ,
        @official_timestamp_col VARCHAR(128) ,
        @c_drop CURSOR ,
        @stmt NVARCHAR(MAX) ,
        @filter NVARCHAR(MAX) = '' ,
        @now VARCHAR(64) = CONVERT(VARCHAR(64), GETDATE(), 120) ,
        @start_ts VARCHAR(64) = CONVERT(VARCHAR(64), GETDATE(), 120) ,
        @last_refresh_dt VARCHAR(64) ,
        @rowcount INT;

	
    BEGIN
        SET NOCOUNT ON;
        SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
        RAISERROR('****	%s	Refreshing table %s data: Starting', 10, 1, @now, @target_table) WITH NOWAIT;
	
	-----------------------------------------------
	--#region: Ensure sys_sffields is up to date --
	-----------------------------------------------
        IF ( EXISTS ( SELECT TOP 1
                                1
                      FROM      sys.tables
                      WHERE     object_id = OBJECT_ID('dbo.sys_sffields')
                                AND create_date < GETDATE() - .25 
								) )
            BEGIN
                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	Detected dbo.sys_sffields has not been updated in the past 24 hours: Updating', 10, 1, @now, @table) WITH NOWAIT;
		
                IF ( OBJECT_ID('dbo.sys_sffields_tmp') IS NOT NULL )
                    DROP TABLE dbo.sys_sffields_tmp;

                SELECT  *
                INTO    dbo.sys_sffields_tmp
                FROM    dbo.sys_sffields
                WHERE   1 = 2;

                INSERT  INTO dbo.sys_sffields_tmp
                        EXEC
                            ( 'select * from ' + @linked_server
                              + '...sys_sffields'
                            );

                ALTER TABLE dbo.sys_sffields_tmp ADD CONSTRAINT pk_sys_sffields_tmp PRIMARY KEY (ObjectName, name);
		
                DROP TABLE dbo.sys_sffields;
                EXEC dbo.sp_rename 'dbo.sys_sffields_tmp', 'sys_sffields';
                EXEC dbo.sp_rename 'pk_sys_sffields_tmp', 'pk_sys_sffields';

                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	Detected dbo.sys_sffields has not been updated in the past 24 hours: Finished', 10, 1, @now, @table) WITH NOWAIT;
		
            END;
	--#endregion --

	-----------------------------------------------
	--#region: Ensure sys_sfobjects is up to date --
	-----------------------------------------------
        IF ( EXISTS ( SELECT TOP 1
                                1
                      FROM      sys.tables
                      WHERE     object_id = OBJECT_ID('dbo.sys_sfobjects')
                                AND create_date < GETDATE() - .25 
								) )
            BEGIN
                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	Detected dbo.sys_sfobjects has not been updated in the past 24 hours: Updating', 10, 1, @now, @table) WITH NOWAIT;
		
                IF ( OBJECT_ID('dbo.sys_sfobjects_tmp') IS NOT NULL )
                    DROP TABLE dbo.sys_sfobjects_tmp;

                SELECT  *
                INTO    dbo.sys_sfobjects_tmp
                FROM    dbo.sys_sfobjects
                WHERE   1 = 2;

                INSERT  INTO dbo.sys_sfobjects_tmp
                        EXEC
                            ( 'select * from ' + @linked_server
                              + '...sys_sfobjects'
                            );

                ALTER TABLE dbo.sys_sfobjects_tmp ADD CONSTRAINT pk_sys_sfobjects_tmp PRIMARY KEY (name);
		
                DROP TABLE dbo.sys_sfobjects;
                EXEC dbo.sp_rename 'dbo.sys_sfobjects_tmp', 'sys_sfobjects';
                EXEC dbo.sp_rename 'pk_sys_sfobjects_tmp', 'pk_sys_sfobjects';

                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	Detected dbo.sys_sfobjects has not been updated in the past 24 hours: Finished', 10, 1, @now, @table) WITH NOWAIT;
		
            END;
	--#endregion --

	-------------------------------------------
	--#region: Initialization and Validation --
	-------------------------------------------
	--~~~~~~~~~~~~~~~~~~~~~~--
	-- Initialize Variables --
	--~~~~~~~~~~~~~~~~~~~~~~--
        SELECT  @table = name																				-- Get Target Table name without adornment --
                ,
                @table_schema = SCHEMA_NAME(schema_id)														-- Get Target Table schema --
                ,
                @table_quoted = QUOTENAME(SCHEMA_NAME(schema_id)) + '.'
                + QUOTENAME(name)					-- Get quoted version of table name --
        FROM    sys.tables
        WHERE   object_id = OBJECT_ID(@target_table);
	
        SET @table_temp = QUOTENAME(@table + '_'
                                    + CAST(NEWID() AS VARCHAR(36)));				-- Get Temp table name --
        SET @table2_temp = QUOTENAME(@table + '_'
                                     + CAST(NEWID() AS VARCHAR(36)));				-- Get Temp table name
        SET @table_hist = QUOTENAME(@table + '_'
                                    + CAST(NEWID() AS VARCHAR(36)));				-- Get Histogram table name
	
	-- Get Timestamp Field for table, but we prefer to use CreatedDate if it's there (hashing purposes) --
        SELECT  @official_timestamp_col = TimestampField
        FROM    dbo.sys_sfobjects
        WHERE   name = @source_object;
        SELECT  @timestamp_col = TimestampField
        FROM    dbo.sys_sfobjects
        WHERE   name = @source_object;
        IF ( EXISTS ( SELECT TOP 1
                                1
                      FROM      sys.columns
                      WHERE     object_id = OBJECT_ID(@table)
                                AND name = 'CreatedDate' ) )
            SET @timestamp_col = 'CreatedDate';

        SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
        RAISERROR('%s	Linked Server Name: %s'			, 10, 1, @now, @linked_server			) WITH NOWAIT;
        RAISERROR('%s	SFDC Object Name: %s'			, 10, 1, @now, @source_object			) WITH NOWAIT;
        RAISERROR('%s	Target Table Name: %s'			, 10, 1, @now, @table					) WITH NOWAIT;
        RAISERROR('%s	Quoted Target Table Schema: %s'	, 10, 1, @now, @table_schema			) WITH NOWAIT;
        RAISERROR('%s	Quoted Target Table Name: %s'	, 10, 1, @now, @table_quoted			) WITH NOWAIT;
        RAISERROR('%s	Temp Table Name: %s'			, 10, 1, @now, @table_temp				) WITH NOWAIT;
        RAISERROR('%s	Temp2 Table Name: %s'			, 10, 1, @now, @table2_temp				) WITH NOWAIT;
        RAISERROR('%s	Hist Table Name: %s'			, 10, 1, @now, @table_hist				) WITH NOWAIT;
        RAISERROR('%s	Official Timestamp Column: %s'	, 10, 1, @now, @official_timestamp_col	) WITH NOWAIT;
        RAISERROR('%s	Hashing Timestamp Column: %s'	, 10, 1, @now, @timestamp_col			) WITH NOWAIT;
	
	--raiserror('%s	Formula Fields Table Name: %s'	, 10, 1, @now, @table_formula_fields) with nowait;

	--~~~~~~~~~~~~--
	-- Validation --
	--~~~~~~~~~~~~--
	-- Check for Id on table --
        IF ( NOT EXISTS ( SELECT TOP 1
                                    1
                          FROM      sys.columns
                          WHERE     object_id = OBJECT_ID(@table)
                                    AND name = 'Id' )
           )
            BEGIN
                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	Local table %s does not contain column Id', 16, 1, @now) WITH NOWAIT;
                RETURN;
            END;

	-- Check for Timestemp field on local table --
        IF ( NOT EXISTS ( SELECT TOP 1
                                    1
                          FROM      sys.columns
                          WHERE     object_id = OBJECT_ID(@table)
                                    AND name = @timestamp_col )
           )
            BEGIN
                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	Local table %s does not contain column %s.  The sync cannot continue without this column.', 16, 1, @now, @timestamp_col) WITH NOWAIT;
                RETURN;
            END;

	--#region: Cursor declarations --
        SET @c_drop = CURSOR FOR
		SELECT
			stmt = 'alter table ' + @table_quoted + ' drop column ' + s.Name
		FROM dbo.sys_sffields sf
			RIGHT JOIN (
				SELECT
					t.name AS ObjectName
					,c.name AS Name
				FROM sys.tables t
					JOIN sys.columns c
						ON t.object_id = c.object_id
				WHERE t.object_id = OBJECT_ID(@table)
			) s
			ON sf.ObjectName = s.ObjectName
			AND sf.Name = s.Name
		WHERE sf.Name IS NULL;
	--#endregion --
	--#endregion --

	---------------------------------------------------------
	--#region: Drop columns that don't exist in Salesforce --
	---------------------------------------------------------
        SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
        RAISERROR('%s	Dropping columns that don''t exist in Salesforce: Starting', 10, 1, @now) WITH NOWAIT;

        OPEN @c_drop;
        FETCH NEXT FROM @c_drop INTO @stmt;
        WHILE ( @@fetch_status = 0 )
            BEGIN
                SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                RAISERROR('%s	%s', 10, 1, @now, @stmt) WITH NOWAIT;
                EXEC(@stmt);
                FETCH NEXT FROM @c_drop INTO @stmt;
            END;
        CLOSE @c_drop;

        SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
        RAISERROR('%s	Dropping columns that don''t exist in Salesforce: Finish', 10, 1, @now) WITH NOWAIT;

	--#endregion --

	--------------------------------
	--#region: Refresh Table Data --
	--------------------------------
        BEGIN TRY
            SET @start_ts = CONVERT(CHAR(19), GETUTCDATE(), 126) + 'Z';
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Refreshing table %s data: Starting', 10, 1, @now, @table_quoted) WITH NOWAIT;

		--#region: Get list of current columns on object --
            WITH    cols
                      AS ( SELECT   name AS name ,
                                    NTILE(2) OVER ( ORDER BY column_id ) AS grp
                           FROM     sys.columns
                           WHERE    object_id = OBJECT_ID(@table)
                                    AND name != 'Id'
                         )
                SELECT  @col_list = 'Id' + (			-- All columns
                                             SELECT ',' + name
                                             FROM   cols
                                           FOR
                                             XML PATH('')
                                           ) ,
                        @col_list1 = 'Id' + (			-- Front half of table
                                              SELECT    ',' + name
                                              FROM      cols
                                              WHERE     grp = 1
                                            FOR
                                              XML PATH('')
                                            ) ,
                        @col_list2 = 'Id' + (			-- Back half of table
                                              SELECT    ',' + name
                                              FROM      cols
                                              WHERE     grp = 2
                                            FOR
                                              XML PATH('')
                                            );

            SELECT  @col_list_update = STUFF(( SELECT   ',t.' + name + ' = '
                                                        + 's.' + name
                                               FROM     sys.columns
                                               WHERE    object_id = OBJECT_ID(@table)
                                                        AND name NOT IN ( 'Id' )
                                               ORDER BY column_id
                                             FOR
                                               XML PATH('')
                                             ), 1, 1, '');
		--#endregion --

		--#region: Get last refresh date
            IF ( @refresh_date IS NULL )
                BEGIN
			--select @last_refresh_dt = cast(value as varchar(64))
			--from sys.extended_properties
			--where class_desc = 'OBJECT_OR_COLUMN'
			--	and major_id = object_id(@table_quoted)
			--	and name = 'SFDC_LastRefreshDateTime';
                    SELECT  @last_refresh_dt = CONVERT(CHAR(19), LastRefreshTime, 126)
                            + 'Z'
                    FROM    sfdc_syncschedule
                    WHERE   TblName = ( @table_quoted );

                    IF ( @last_refresh_dt IS NULL )
                        BEGIN
                            SET @stmt = '
					select @r = convert(varchar(64), dateadd(minute, -15, isnull(max('
                                + @timestamp_col
                                + '), ''19000101'')), 126) + ''Z'' from '
                                + @table_quoted;
                            EXEC dbo.sp_executesql @statement = @stmt,
                                @params = N'@r varchar(64) out',
                                @r = @last_refresh_dt OUT;
                        END;
                END;
            ELSE
                SET @last_refresh_dt = CONVERT(CHAR(19), @refresh_date, 126)
                    + 'Z';
		
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Setting Last Refresh Date: %s', 10, 1, @now, @last_refresh_dt) WITH NOWAIT;
		--#endregion --

		--#region: Refresh since last refresh date
            SET @stmt = '
		if (exists(select top 1 1 from sys.tables where object_id = object_id('''
                + @table_temp + ''')))
			drop table ' + @table_temp + ';
		select ' + @col_list1 + ' into ' + @table_temp + ' from '
                + @table_quoted + ' where 1 = 2;
		alter table ' + @table_temp + ' alter column Id nchar(18) not null;
		alter table ' + @table_temp + ' add constraint [pk_'
                + REPLACE(REPLACE(@table_temp, '[', ''), ']', '')
                + '] primary key (Id) with (data_compression=page);
		insert into ' + @table_temp + ' with(tablock)
		select * from openquery(' + @linked_server + ', ''select '
                + @col_list1 + ' from ' + @source_object
                + ' where SystemModstamp >= ' + @last_refresh_dt
                + ''') a;
		
		if (exists(select top 1 1 from sys.tables where object_id = object_id('''
                + @table2_temp + ''')))
				drop table ' + @table2_temp + ';
		select ' + @col_list2 + ' into ' + @table2_temp + ' from '
                + @table_quoted + ' where 1 = 2;
		alter table ' + @table2_temp + ' alter column Id nchar(18) not null;
		alter table ' + @table2_temp + ' add constraint [pk_'
                + REPLACE(REPLACE(@table2_temp, '[', ''), ']', '')
                + '] primary key (Id) with (data_compression=page);
		insert into ' + @table2_temp + ' with(tablock)
		select * from openquery(' + @linked_server + ', ''select '
                + @col_list2 + ' from ' + @source_object
                + ' where SystemModstamp >= ' + @last_refresh_dt + ''') a;
		';

            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Salesforce last refresh date extract SELECT Statement: Starting', 10, 1, @now) WITH NOWAIT;

            EXEC(@stmt);

            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Salesforce last refresh date extract SELECT Statement: Finished', 10, 1, @now) WITH NOWAIT;
		--#endregion --

		--#region: Update Data
            SET @stmt = '
		if (object_id(''' + @table_temp + ''') is not null)
		begin
			with source as (
				select tmp1.' + @col_list + '
				from ' + @table_temp + ' tmp1
					join ' + @table2_temp + ' tmp2
						on tmp1.id = tmp2.id
			)
			update t
			set ' + @col_list_update + '
			from ' + @table_quoted + ' t
				join source s
					on t.Id = s.Id
			where t.' + @timestamp_col + ' != s.' + @timestamp_col + '
				or t.' + @official_timestamp_col + ' != s.'
                + @official_timestamp_col + ';
		end';
	
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Update Statement - last refresh date: Starting', 10, 1, @now) WITH NOWAIT;
	
            EXEC(@stmt);
            SET @rowcount = @@rowcount;

            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Update Statement - last refresh date: %d rows affected', 10, 1, @now, @rowcount) WITH NOWAIT;
		
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Update Statement - last refresh date: Finished', 10, 1, @now) WITH NOWAIT;

		--#endregion --

		--#region: Insert New Data
            SET @stmt = '
		if (object_id(''' + @table_temp + ''') is not null)
		begin
			with source as (
				select tmp1.' + @col_list + '
				from ' + @table_temp + ' tmp1
					join ' + @table2_temp + ' tmp2
						on tmp1.id = tmp2.id
			)
			insert into ' + @table_quoted + ' with(tablock)
			(' + @col_list + ')
			select s.*
			from source s
				left join ' + @table_quoted + ' t
					on t.Id = s.Id
			where t.Id is NULL;
		end';
	
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Insert Statement - last refresh date: Starting', 10, 1, @now) WITH NOWAIT;
	
            EXEC(@stmt);
            SET @rowcount = @@rowcount;

            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Insert Statement - last refresh date: %d rows affected', 10, 1, @now, @rowcount) WITH NOWAIT;
		
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Insert Statement - last refresh date: Finished', 10, 1, @now) WITH NOWAIT;
		--#endregion

		--#region: Fetch Problem data ranges from Salesforce
            SET @stmt = '
declare @c cursor
	,@yr int
	,@wk int
	,@prev_yr int
	,@prev_wk int
	,@rng_start datetime
	,@rng_end datetime
	,@loop_cntr int = 1
	,@loop_stmt varchar(max);

	-- Cursor returns list of calendar weeks with different record counts
	set @c = cursor for
		select top 5
			isnull(l.yr, sf.yr) as yr
			,isnull(l.wk, sf.wk) as wk
		from
			(
				select
					year(' + @timestamp_col + ') as yr
					,ceiling(datepart(dayofyear, ' + @timestamp_col
                + ') / 7.) as wk
					,count(*) as cnt
					,count(distinct ' + @official_timestamp_col
                + ') as cnt_dist
					,min(' + @official_timestamp_col + ') as min_date
					,max(' + @official_timestamp_col + ') as max_date
				from ' + @table_quoted + '
				group by
					year(' + @timestamp_col + ')
					,ceiling(datepart(dayofyear, ' + @timestamp_col + ') / 7.)
			) l
			full join (
				select
					yr
					,wk
					,cnt
					,cnt_dist
					,min_date
					,max_date
				from openquery(' + @linked_server
                + ', ''select calendar_year(' + @timestamp_col
                + ') yr, week_in_year(' + @timestamp_col
                + ') wk, count() cnt, count_distinct('
                + @official_timestamp_col + ') cnt_dist, min('
                + @official_timestamp_col + ') min_date, max(' + @official_timestamp_col + ') max_date from ' + @source_object
                + ' group by calendar_year(' + @timestamp_col
                + '), week_in_year(' + @timestamp_col + ')'') a
			) sf
				on l.yr = sf.yr
				and l.wk = sf.wk
		where sf.cnt != l.cnt
			or sf.cnt_dist != l.cnt_dist
			or l.yr is null
			or sf.yr is null
			or l.min_date != sf.min_date
			or l.max_date != sf.max_date
		order by sf.cnt, yr, wk


if (exists(select top 1 1 from sys.tables where object_id = object_id('''
                + @table_hist + ''')))
	drop table ' + @table_hist + ';
create table ' + @table_hist
                + ' (rng_start datetime not null, rng_end datetime not null, primary key (rng_start));

-- Compressing date ranges
open @c;
fetch next from @c into @yr, @wk
while @@fetch_status = 0
begin
	if (@rng_start is null)
		set @rng_start = dateadd(week, @wk - 1, cast(@yr as char(4)) + ''0101'');

	if (@yr = @prev_yr and @wk != @prev_wk + 1 or @yr != @prev_yr)
	begin
		set @rng_end = dateadd(week, @prev_wk, cast(@prev_yr as char(4)) + ''0101'');

		-- Record range and reset
		insert into ' + @table_hist
                + ' values (@rng_start, @rng_end);
		set @rng_start = dateadd(week, @wk - 1, cast(@yr as char(4)) + ''0101'');
		set @rng_end = NULL;
	end
	
	set @prev_yr = @yr;
	set @prev_wk = @wk;

	fetch next from @c into @yr, @wk
end
close @c;
deallocate @c;

-- Record final range
if(@rng_start is not null)
begin
	set @rng_end = dateadd(week, @prev_wk, cast(@prev_yr as char(4)) + ''0101'');
	insert into ' + @table_hist + ' values (@rng_start, @rng_end);
end

select @filter = stuff((
	select
		'' or (' + @timestamp_col
                + ' >= '' + replace(convert(varchar(32), rng_start, 120), '' '', ''T'') + ''Z and '
                + @timestamp_col
                + ' < '' + replace(convert(varchar(32), rng_end, 120), '' '', ''T'') + ''Z)''
	From ' + @table_hist + '
	order by 1
	for xml path(''''), root(''r''), type
).value(''/r[1]'', ''varchar(max)''), 1, 4, '''');
';
            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Salesforce extract SELECT Statement Calculation: Starting', 10, 1, @now) WITH NOWAIT;

            EXEC sp_executesql @statement = @stmt,
                @params = N'@filter varchar(max) out', @filter = @filter OUT;

            SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
            RAISERROR('%s	Salesforce extract SELECT Statement Calculation: Finished', 10, 1, @now) WITH NOWAIT;

            IF @filter IS NOT NULL
                BEGIN
                    SET @stmt = '
			if (exists(select top 1 1 from sys.tables where object_id = object_id('''
                        + @table_temp + ''')))
				drop table ' + @table_temp + ';
			select ' + @col_list1 + ' into ' + @table_temp + ' from '
                        + @table_quoted + ' where 1 = 2;
			alter table ' + @table_temp
                        + ' alter column Id nchar(18) not null;
			alter table ' + @table_temp + ' add constraint [pk_'
                        + REPLACE(REPLACE(@table_temp, '[', ''), ']', '')
                        + '] primary key (Id) with (data_compression=page);
			insert into ' + @table_temp + ' with(tablock)
			select * from openquery(' + @linked_server + ', ''select '
                        + @col_list1 + ' from ' + @source_object + ' where '
                        + ISNULL(@filter, '')
                        + ''') a;
		
			if (exists(select top 1 1 from sys.tables where object_id = object_id('''
                        + @table2_temp + ''')))
				drop table ' + @table2_temp + ';
			select ' + @col_list2 + ' into ' + @table2_temp + ' from '
                        + @table_quoted + ' where 1 = 2;
			alter table ' + @table2_temp
                        + ' alter column Id nchar(18) not null;
			alter table ' + @table2_temp + ' add constraint [pk_'
                        + REPLACE(REPLACE(@table2_temp, '[', ''), ']', '')
                        + '] primary key (Id) with (data_compression=page);
			insert into ' + @table2_temp + ' with(tablock)
			select * from openquery(' + @linked_server + ', ''select '
                        + @col_list2 + ' from ' + @source_object + ' where '
                        + ISNULL(@filter, '') + ''') a;
			';

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Salesforce extract SELECT Statement: Starting', 10, 1, @now) WITH NOWAIT;

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Salesforce extract SELECT Statement Predicate: 
			%s', 10, 1, @now, @filter) WITH NOWAIT;

                    EXEC(@stmt);

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Salesforce extract SELECT Statement: Finished', 10, 1, @now) WITH NOWAIT;
			--#endregion --

			--#region: Delete Data
                    SET @stmt = '
			if (object_id(''' + @table_temp + ''') is not null)
			begin
				delete t from ' + @table_quoted + ' t
				where 
					exists(
						select top 1 1
						from ' + @table_hist + ' hist
						where t.' + @timestamp_col + ' >= hist.rng_start
							and t.' + @timestamp_col + ' < hist.rng_end
					)
					and not exists (
						select top 1 1
						from ' + @table_temp + ' s 
						where t.Id = s.Id
					);
			end';
	
                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	DELETE Statement: Starting', 10, 1, @now) WITH NOWAIT;

                    EXEC(@stmt);
                    SET @rowcount = @@rowcount;

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	DELETE Statement: %d rows affected', 10, 1, @now, @rowcount) WITH NOWAIT;

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	DELETE Statement: Finished', 10, 1, @now) WITH NOWAIT;
			--#endregion --

			--#region: Update Data
                    SET @stmt = '
			if (object_id(''' + @table_temp + ''') is not null)
			begin
				with source as (
					select tmp1.' + @col_list + '
					from ' + @table_temp + ' tmp1
						join ' + @table2_temp + ' tmp2
							on tmp1.id = tmp2.id
				)
				update t
				set ' + @col_list_update + '
				from ' + @table_quoted + ' t
					join source s
						on t.Id = s.Id
				where t.' + @timestamp_col + ' != s.' + @timestamp_col + '
					or t.' + @official_timestamp_col + ' != s.'
                        + @official_timestamp_col + ';
			end';
	
                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Update Statement: Starting', 10, 1, @now) WITH NOWAIT;
	
                    EXEC(@stmt);
                    SET @rowcount = @@rowcount;

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Update Statement: %d rows affected', 10, 1, @now, @rowcount) WITH NOWAIT;
		
                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Update Statement: Finished', 10, 1, @now) WITH NOWAIT;

			--#endregion --

			--#region: Insert New Data
                    SET @stmt = '
			if (object_id(''' + @table_temp + ''') is not null)
			begin
				with source as (
					select tmp1.' + @col_list + '
					from ' + @table_temp + ' tmp1
						join ' + @table2_temp + ' tmp2
							on tmp1.id = tmp2.id
				)
				insert into ' + @table_quoted + ' with(tablock)
				(' + @col_list + ')
				select s.*
				from source s
					left join ' + @table_quoted + ' t
						on t.Id = s.Id
				where t.Id is NULL;
			end';
	
                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Insert Statement: Starting', 10, 1, @now) WITH NOWAIT;
	
                    EXEC(@stmt);
                    SET @rowcount = @@rowcount;

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Insert Statement: %d rows affected', 10, 1, @now, @rowcount) WITH NOWAIT;
		
                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Insert Statement: Finished', 10, 1, @now) WITH NOWAIT;
			--#endregion --
                END;

		--#region: Formula Fields Refresh
            IF ( @refresh_formulas = 1 )
                BEGIN
                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Refreshing Formulas: Starting', 10, 1, @now) WITH NOWAIT;

                    EXEC [dbo].[SFDC_RefreshObjectFormulaData] @linked_server,
                        @source_object, @target_table;

                    SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
                    RAISERROR('%s	Refreshing Formulas: Finished', 10, 1, @now) WITH NOWAIT;
                END;
		--#endregion

		--#region: Clean up temp table
            IF ( @clean_up_temps = 1 )
                BEGIN
                    SET @stmt = '
			if (object_id(''' + @table_temp + ''') is not null)
				drop table ' + @table_temp + ';
			if (object_id(''' + @table2_temp + ''') is not null)
				drop table ' + @table2_temp + ';
			if (object_id(''' + @table_hist + ''') is not null)
				drop table ' + @table_hist + ';';

                    EXEC(@stmt);
                END;
		--#endregion

		--#region: Mark Last Update date in extended properties
		--if exists(select top 1 1 from sys.extended_properties where name = 'SFDC_LastRefreshDateTime' and class_desc = 'OBJECT_OR_COLUMN' and major_id = object_id(@table_quoted))
		--begin
		--	exec dbo.sp_updateextendedproperty @name='SFDC_LastRefreshDateTime', @value=@start_ts
		--		,@level0type = N'Schema', @level0name = @table_schema
		--		,@level1type = N'Table',  @level1name = @table;
		--end
		--else
		--begin
		--	exec dbo.sp_addextendedproperty @name='SFDC_LastRefreshDateTime', @value=@start_ts
		--		,@level0type = N'Schema', @level0name = @table_schema
		--		,@level1type = N'Table',  @level1name = @table;
		--end
		--#endregion
		--#region: Mark Last Update date in SFDC_SyncSchedule
            IF EXISTS ( SELECT TOP 1
                                *
                        FROM    [dbo].sfdc_syncschedule
                        WHERE   TblName = @table_quoted )
                BEGIN
                    UPDATE  dbo.SFDC_SyncSchedule
                    SET     LastRefreshTime = CONVERT(VARCHAR(64), CAST(@start_ts AS DATETIMEOFFSET), 127)
                    WHERE   TblName = @table_quoted; 
                END;
            ELSE
                BEGIN
                    INSERT  INTO dbo.SFDC_SyncSchedule
                            ( TblName ,
                              LastRefreshTime
                            )
                            SELECT  @table_quoted ,
                                    CONVERT(VARCHAR(64), CAST(@start_ts AS DATETIMEOFFSET), 127);
                END;


		--#endregion

        END TRY
        BEGIN CATCH
            DECLARE @err_num VARCHAR(8) ,
                @err_sev VARCHAR(8) ,
                @err_state VARCHAR(8) ,
                @err_proc VARCHAR(128) ,
                @err_line VARCHAR(8) ,
                @err_msg VARCHAR(2048);
            SELECT  @err_num = ERROR_NUMBER() ,
                    @err_sev = ERROR_SEVERITY() ,
                    @err_state = ERROR_STATE() ,
                    @err_proc = ERROR_PROCEDURE() ,
                    @err_line = ERROR_LINE() ,
                    @err_msg = ERROR_MESSAGE();
		
		-- Reraise the error and get out!
            RAISERROR('Error in procedure %s on line %s: %s.
		Error Number: %s, Severity: %s, State: %s', 16, 10,
			@err_proc
			,@err_line
			,@err_msg
			,@err_num
			,@err_sev
			,@err_state
			);
            RETURN;
        END CATCH;

        SET @now = CONVERT(VARCHAR(64), GETDATE(), 120);
        RAISERROR('****	%s	Refreshing table %s data: Finished', 10, 1, @now, @table) WITH NOWAIT;
	--#endregion --
    END;


