use WHiring;
go
exec sp_configure 'clr_enabled', 1;
go
reconfigure;
go
create assembly GetCountbyAge
	from 'D:\Subject\BD3\Lab\Lab3\Lab3\bin\Debug\Lab3.dll';

go
create procedure GetCountbyAge (@min int, @max int)
as external name GetCountbyAge.StoredProcedures.GetCountbyAge

go
declare @num int
exec @num = GetCountbyAge '20', '50'
print @num
