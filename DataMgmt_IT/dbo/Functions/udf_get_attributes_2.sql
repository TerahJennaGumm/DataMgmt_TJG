
CREATE function [dbo].[udf_get_attributes] (@attributeObject nvarchar(255) = null)
returns  @attributes  table
(
Id int identity (1,1)
,Attribute nvarchar(255)
) as  begin
insert @attributes(Attribute)
  select 
	 ltrim(rtrim(attr.Attribute)) as Attribute
	from [dbo].Attributes as attr where attr.AttributeObject = @attributeObject and isnull(attr.Active,0) = 1
	group by attr.Attribute
return 
end
