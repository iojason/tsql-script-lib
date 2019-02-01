--Cursor that will search for specific data in a database and provide the table name and column name that it is in.
--change <DATABASE_NAME>, @search and @exact_search variables before executing.
--Created by Jason Phan (hi@jasondphan.com) sometime between 2013-2014.

use <DATABASE_NAME>
go

declare @search varchar(1000), declare @exact_search bit
set @search = 'DATA_YOU_WANT_TO_SEARCH'
set @exact_search = '<1 or 0> (e.g. set @exact = 1)'


declare find_text_cursor cursor for
select so.name, sc.name
from syscolumns sc
inner join sysobjects so on sc.id = so.id
where so.type = 'U'
and sc.type not in (34, 35, 37, 45, 50, 59) -- no blobs and such

open find_text_cursor

declare @table_name varchar(1000)
declare @column_name varchar(1000)

fetch next from find_text_cursor into @table_name, @column_name
while @@fetch_status = 0
begin
IF @exact_search = 1
  -- = operator search will perform much faster and find exactly what you need.
  execute ('
  declare @count int
  select @count = count(*) from [' + @table_name + '] where cast(' + @column_name + ' as varchar) = ''' + @search + '''
  if (@count > 0)
  print ''Found ' + @search + ' in table ' + @table_name + '.' + @column_name + '!''
  ')
ELSE
  -- LIKE search will perform slower.
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
