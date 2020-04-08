create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);
	
go
create procedure generateXML
as
declare @x XML
set @x = (Select cus.Name [Name], cus.Gender[Gendere], serv.ServiceName[Service], serv.ServiceCost[Cost], GETDATE() [Date] 
from Customer cus join Service serv on serv.ServiceCustomer = cus.Name
FOR XML AUTO);
SELECT @x

go
execute generateXML;

go
create procedure InsertInReport
as
DECLARE  @s XML  
SET @s = (Select cus.Name [Name], cus.Gender[Gendere], serv.ServiceName[Service], serv.ServiceCost[Cost], GETDATE() [Date] 
from Customer cus join Service serv on serv.ServiceCustomer = cus.Name FOR XML  raw);
insert into Report values(@s);

go
execute InsertInReport
  select * from Report;


create primary xml index My_XML_Index on Report(xml_column)

create xml index Second_XML_Index on Report(xml_column)
using xml index My_XML_Index for path


go
create procedure SelectData
as
select r.id, m.c.value('@Name', 'nvarchar(max)') as [name] from Report as r cross apply r.xml_column.nodes('/row') as m(c)
go

execute SelectData
