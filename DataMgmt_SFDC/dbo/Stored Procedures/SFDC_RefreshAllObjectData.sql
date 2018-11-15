





CREATE PROCEDURE [dbo].[SFDC_RefreshAllObjectData]
    @lnk_server VARCHAR(64) --= 'SALESFORCE_SANDBOX'
    ,
    @formula_max_age INT = -1
AS
    DECLARE @tables CURSOR ,
        @t_name VARCHAR(128) ,
        @stmt VARCHAR(MAX) ,
        @refresh_formulas BIT = 0 ,
        @c CURSOR;

    SET @c = CURSOR FOR
		SELECT
			'drop table ' + QUOTENAME(name) + ';'
		FROM sys.tables
		WHERE create_date < GETDATE() - 7
			AND name LIKE '%-[0-F][0-F][0-F][0-F]-[0-F][0-F][0-F][0-F]-[0-F][0-F][0-F][0-F]-%'
		ORDER BY create_date;


    SET @tables = CURSOR FORWARD_ONLY STATIC FOR
        SELECT name
		FROM sys.tables
        WHERE schema_id = SCHEMA_ID('dbo')
            AND name NOT IN ('sys_sffields', 'sys_sfobjects', 'sys_sfpicklists', 'TableRefreshTime', 'sysssislog','UserRecordAccess','Vote','ContentDocumentLink','FeedItem','KnowledgeArticleVersion'
			,'task','SFDC_SyncSchedule','eventlogfile')
            AND name NOT LIKE '%import'
			AND name NOT LIKE 'Feed%'
			AND name NOT LIKE '%Feed'
            AND name NOT LIKE '%________-____-____-____-____________'
			AND name NOT LIKE '%________-____-____-____-____________[_][UID]'
			AND name NOT LIKE '%________-____-____-____-____________[_][_][UID]'
			AND name NOT LIKE '%[_]Delta____-__-__T__:__:__%'
			AND name NOT LIKE '%[_]Deleted____-__-__T__:__:__%'
            AND name NOT LIKE '%_previous'
			AND name NOT LIKE 'MSp%'
			AND name NOT LIKE 'sys%'
			And name NOT LIKE '%history%'
		ORDER BY 1;

    BEGIN
	---------------------------------
	-- Remove any temporary tables --
	---------------------------------
        OPEN @c;
        FETCH NEXT FROM @c INTO @stmt;
        WHILE ( @@fetch_status = 0 )
            BEGIN
                EXEC(@stmt);
                FETCH NEXT FROM @c INTO @stmt;
            END;
        DEALLOCATE @c;
	
    ---------------------
	-- Refresh objects --
	---------------------
        OPEN @tables;
    
        FETCH NEXT FROM @tables INTO @t_name;
        WHILE @@FETCH_STATUS = 0
            BEGIN
		-- Calculate whether or not to refresh formula data
                IF ( @formula_max_age > -1 )
                    SELECT  @refresh_formulas = CASE WHEN DATEDIFF(MINUTE,
                                                              ISNULL(sss.LastFormulaRefresh,
                                                              t.create_date),
                                                              GETUTCDATE()) >= @formula_max_age
                                                     THEN 1
                                                     ELSE 0
                                                END
                    FROM    sys.tables t
                            JOIN SFDC_SyncSchedule sss ON t.object_id = OBJECT_ID(sss.TblName)
                    WHERE   t.object_id = OBJECT_ID(@t_name);
			
			--select @refresh_formulas =
			--	case
			--		when datediff(minute, isnull(cast(ep.value as datetime), t.create_date), getutcdate()) >= @formula_max_age then 1
			--		else 0
			--	end 
			--from sys.tables t
			--	left join sys.extended_properties ep
			--		on t.object_id = ep.major_id
			--		and ep.name = 'SFDC_FormulaLastRefreshDateTime'
			--where t.object_id = object_id(@t_name);	
                ELSE
                    SET @refresh_formulas = 0;

                EXEC [dbo].[SFDC_RefreshObjectData] @lnk_server, @t_name,
                    @t_name, DEFAULT, @refresh_formulas;
        
                FETCH NEXT FROM @tables INTO @t_name;
            END;
    
        DEALLOCATE @tables;
    END;









