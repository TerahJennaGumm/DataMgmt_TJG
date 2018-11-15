CREATE procedure [dbo].[usp_normalize_account_stats]  

as begin

  set nocount on 

  -- process data for n accounts at a time

	declare @account_per_batch_count int = 20000
	,@total_count bigint = 0
	,@batch_count int =  0 
	,@i int = 0
	,@lower_limit bigint = 0
	,@upper_limit bigint = 0
	,@col_list nvarchar(max) = ''
	,@select nvarchar(max) = ''
	,@from nvarchar(max) = ''
	,@sql nvarchar(max) = ''
	,@process_date varchar(30) = convert(varchar(30), getdate(),21)
	,@insert nvarchar(max) = ''

	if OBJECT_ID('account_stats_normalized') is not null
	drop table account_stats_normalized
	    
	set @col_list = ''
	select @col_list = @col_list+ QUOTENAME(udf.Attribute) + ', ' from udf_get_attributes('account') as udf
	set @col_list = SUBSTRING(@col_list, 0, LEN(@col_list))
	print ('** Attributes: **')
	print (@col_list)

	if object_id ('tempdb..#tmp_accounts') is not null
	drop table  #tmp_accounts

	create table #tmp_accounts
	(
		rowId bigint identity (1,1) primary key,
		accountId nchar(18)
	)

  insert #tmp_accounts
  (accountId)
  select 
	stat.AccountId  
	from dbo.[mde_ml_account_stats] as stat
	group by stat.AccountId

  create index idx_tmp_accounts on #tmp_accounts (accountId)
  
  select @total_count = count(distinct accountId) from #tmp_accounts

  -- we may process one more time, but it will return no data
  select @batch_count = (@total_count % @account_per_batch_count) + 1

  while (@i < @batch_count)
  begin   	
	set @lower_limit = @i*(@account_per_batch_count) + 1
	set @upper_limit = (@i+1)*(@account_per_batch_count)
	set @i = @i + 1

	if OBJECT_ID('tempdb..#tmp_stats_acc') is not null
	drop table #tmp_stats_acc

	select stat.AccountId,att.Attribute,stat.AttributeValue into #tmp_stats_acc 
		from dbo.[mde_ml_account_stats] as stat
		inner join Attributes as att on att.Id = stat.AttributeId
		inner join #tmp_accounts as tmp on tmp.accountId = stat.AccountId
		where tmp.rowId between @lower_limit and @upper_limit

		if ((select count(1) from #tmp_stats_acc) > 0)
		begin 

			print ('processing rows: lower limit: '+ cast(@lower_limit as varchar(20)))
			print ('processing rows: upper limit: '+ cast(@upper_limit as varchar(20)))

			set @select = 'select '+''''+@process_date+''''+  ' as ProcessDate,  AccountId as accountId, '+@col_list
			set @from = ' from ( SELECT AccountId,Attribute,AttributeValue FROM #tmp_stats_acc) AS SourceTable PIVOT(max(AttributeValue) FOR Attribute IN('+@col_list+') ) AS PivotTable;'		

			if OBJECT_ID('account_stats_normalized') is null
			begin

			set @select = @select + ' into account_stats_normalized '
			set @sql = @select + @from
			print(@sql)
			exec (@sql)

			end

			else begin 

			set @insert = 'insert account_stats_normalized (ProcessDate,accountId,'+@col_list+' ) '
			set @sql = @insert + @select+@from
			print(@sql)
			exec (@sql)

			end

		end
					
  end

end
 