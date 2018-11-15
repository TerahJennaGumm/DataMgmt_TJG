CREATE function [dbo].[sfdc_fn_Calc18CharId] (@id char(15)) returns char(18)
begin
       declare @return char(18);  

       -- Calculate last 3 characters and append to original
       with num as (
              select 1 as n
                     ,1 as g
              union all
              select n + 1 as n
                     ,g + case when n in (5, 10) then 1 else 0 end as g
              from num
              where n <= 14
       )
       ,calc as (
              select
                     g
                     ,power(2, case when ascii(substring(@id, num.n, 1)) between 65 and 91 then row_number() over (partition by g order by n) - 1 else -1 end) as val
              from num
       )
       select @return = @id + 
              (
                     select
                           substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ012345', sum(val) + 1, 1)
                     from calc
                     group by g
                     for xml path('')
              );
       
       -- Return new value
       return @return;
end

