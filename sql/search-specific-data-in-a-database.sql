--Cursor that will search for specific data in a database and provide the table name and column name that it is in.
--change <DATABASE_NAME> and @search variable before executing.
--Created by Jason Phan (hi@jasondphan.com) sometime between 2013-2014.

use <DATABASE_NAME>
go

declare @search varchar(1000)
set @search = 'DATA_YOU_WANT_TO_SEARCH'


declare find_text_cursor cursor for
select so.name, sc.name
from syscolumns sc
inner join sysobjects so on sc.id = so.id
where so.type = 'U'
and sc.type not in (34, 35, 37, 45, 50, 59) -- no blobs and such

open find_text_cursor

declare @table_name varchar(1000)
declare @column_name varchar(1000)
declare @sql varchar(1000)

fetch next from find_text_cursor into @table_name, @column_name
while @@fetch_status = 0
begin
execute ('
declare @count int
select @count = count(*) from [' + @table_name + '] where cast(' + @column_name + ' as varchar) like ''%' + @search + '%''
if (@count > 0)
print ''Found ' + @search + ' in table ' + @table_name + '.' + @column_name + '!''
')
fetch next from find_text_cursor into @table_name, @column_name
end

close find_text_cursor
deallocate find_text_cursor
