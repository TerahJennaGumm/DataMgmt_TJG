
CREATE PROCEDURE [dbo].[SF_VASQuery]
AS

declare @Result 	int
declare @Command 	nvarchar(4000)
declare @sql		nvarchar(4000)
declare @parmlist	nvarchar(4000)
declare @time_now	char(8)

print '--- Starting SF_VASQuery' + ' ' +  dbo.SF_Version()
declare @refresh_table sysname
declare @delim_refresh_table sysname

-- Put delimeters around names 
set @refresh_table = 'VASSnaps'
set @delim_refresh_table = '[' + @refresh_table + ']'

declare @refresh_exist int

set @refresh_exist = 0
IF EXISTS (SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME=@refresh_table)
        set @refresh_exist = 1
IF (@@ERROR <> 0) GOTO ERR_HANDLER

if (@refresh_exist = 0)
begin
   exec ('Create Table ' + @refresh_table + ' (TotalAvail BigInt null, LargestBlock BigInt null, MultiPage BigInt null, CLR_Multi BigInt null,CLR_VRes BigInt null,CLR_VCmt BigInt null,SnapTime datetime null default CURRENT_TIMESTAMP) ')
   IF (@@ERROR <> 0) GOTO ERR_HANDLER
end

Declare @TotalAvail as Bigint
Declare @LargestBlock as Bigint
Declare @MultiPage as Bigint
Declare @CLR_Multi as Bigint
Declare @CLR_VRes  as Bigint
Declare @CLR_VCmt  as Bigint

-- Get allocations by the MultiPage Manager
-- Unable to retrieve in SQL 2012
--Select @MultiPage = sum(multi_pages_kb) 
--from sys.dm_os_memory_clerks
Select @MultiPage = 0

-- Get CLR memory usage
-- Unable to retrieve in SQL 2012
select @CLR_Multi = 0, 
		@CLR_VRes = sum(virtual_memory_reserved_kb),
		@CLR_VCmt = sum(virtual_memory_committed_kb) from sys.dm_os_memory_clerks 
		where type like '%clr%'


-- Get TotalAvail and LargestBlock
Select @TotalAvail = SUM(CONVERT(BIGINT,Size)*Free)/1024 
      ,@LargestBlock = CAST(MAX(Size) AS BIGINT)/1024 
from
(SELECT 
    Size = VaDump.Size,  
    Free = SUM(CASE(CONVERT(INT, VaDump.Base)^0) WHEN 0 THEN 1 ELSE 0 END) 
FROM 
( 
    SELECT  CONVERT(VARBINARY, SUM(region_size_in_bytes)) 
    AS Size, region_allocation_base_address AS Base 
    FROM sys.dm_os_virtual_address_dump  
    WHERE region_allocation_base_address <> 0x0 
    GROUP BY region_allocation_base_address  
 UNION   
    SELECT CONVERT(VARBINARY, region_size_in_bytes), region_allocation_base_address 
    FROM sys.dm_os_virtual_address_dump 
    WHERE region_allocation_base_address  = 0x0 
) 
AS VaDump 
GROUP BY Size
) as VASummary
where Free <>0

-- Add a VAS snapshot to the table
select @sql = 'insert into ' + @refresh_table + '(TotalAvail, LargestBlock, MultiPage, CLR_Multi, CLR_VRes, CLR_VCmt) '
select @sql = @sql + 'Values(' + Cast(@TotalAvail as nvarchar) + 
							','+ Cast(@LargestBlock as nvarchar) + 
							','+ Cast(@MultiPage as nvarchar) + 
							','+ Cast(@CLR_Multi as nvarchar) + 
							','+ Cast(@CLR_VRes as nvarchar) + 
							','+ Cast(@CLR_VCmt as nvarchar) + ')'
print @sql
exec sp_executesql @sql

print '--- Ending SF_VASQuery. Operation successful.'
return 0

ERR_HANDLER:
set NOCOUNT OFF
print('--- Ending SF_VASQuery. Operation FAILED.')
RAISERROR ('--- Ending SF_VASQuery. Operation FAILED.',16,1)
return 1


