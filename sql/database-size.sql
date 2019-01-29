--Database Size.
--Created by Jason Phan (hi@jasondphan.com) sometime between 2013-2014.

--see all databases of user type.
SELECT *
FROM sys.master_files
WHERE database_id = 12

SELECT database_name = DB_NAME(database_id) ,
       log_size_mb = CAST(SUM(CASE
                                  WHEN type_desc = 'LOG' THEN SIZE
                              END) * 8 / 1024 AS DECIMAL(8,2)) ,
       row_size_mb = CAST(SUM(CASE
                                  WHEN type_desc = 'ROWS' THEN SIZE
                              END) * 8 / 1024 AS DECIMAL(8,2)) ,
       total_size_mb = CAST(SUM(SIZE) * 8 / 1024 AS DECIMAL(8,2))
FROM sys.master_files WHERE database_id = 12
GROUP BY database_id
SELECT name --,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
,SIZE/128.0 AS TotalSpaceMB
FROM sys.master_files -- sys.database_files
WHERE database_id = 12
