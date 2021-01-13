/*
# Create dummy database to test transaction log growth.



Yes, the scenario will be very lop-sided, but that's the point
*/

/*
Create database:
*/

CREATE DATABASE [TLogGrowth_Test]
 ON  PRIMARY 
( NAME = N'TLogGrowth_Test', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\TLogGrowth_Test.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TLogGrowth_Test_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\DATA\TLogGrowth_Test_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO

USE TLogGrowth_Test
GO

/*
Create tables: Parent and Child.
*/

USE TLogGrowth_Test
GO

CREATE TABLE dbo.Parent (Parent_Key varchar(10) NOT NULL PRIMARY KEY CLUSTERED)
GO

CREATE TABLE dbo.Child (Child_Key int IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
    Parent_Key varchar(10) NOT NULL, 
    CONSTRAINT FK_Child_Parent FOREIGN KEY (Parent_Key) REFERENCES dbo.Parent (Parent_Key)
        ON DELETE CASCADE ON UPDATE CASCADE
    )
GO

/*
Create data. One Parent record and 1 million Child records
*/

INSERT INTO dbo.Parent (Parent_Key) VALUES ('Parent Rec');

INSERT INTO dbo.Child (Parent_Key) SELECT Parent_Key FROM Parent;

WHILE (select count(*) from dbo.Child) < 1000000
BEGIN
    INSERT INTO dbo.Child (Parent_Key)
    SELECT Parent_Key FROM dbo.Child
END


SELECT count(*) FROM dbo.Child

/*
Confirm the size of the database
*/

SELECT name, size/1024 as SizeInMB FROM sys.database_files

/*
Update Parent Record
*/

UPDATE Parent SET Parent_Key = 'My Parent' WHERE Parent_Key = 'Parent Rec'

/*
Now check the transaction log size again:
*/

SELECT name, size/1024 as SizeInMB FROM sys.database_files

/*
Let's read from the transaction logs themselves:
*/

SELECT  count_BIG(*)
FROM fn_dblog(NULL,NULL)

SELECT [Transaction ID], count(*)
FROM fn_dblog(NULL,NULL)
GROUP BY [Transaction ID]
ORDER BY count(*) DESC

SELECT Operation, count(*) FROM fn_dblog(NULL,NULL) WHERE [Transaction ID] = '0000:0000125d'
GROUP BY Operation

/*
What if there was an index on that foreign key?
*/

CREATE NONCLUSTERED INDEX IDX_Child_Parent ON dbo.Child (Parent_Key)

UPDATE Parent SET Parent_Key = 'Parent 1' WHERE Parent_Key = 'My Parent'

/*
Now let's check the sizes again.....
*/

SELECT name, size/1024 as SizeInMB FROM sys.database_files

SELECT [Transaction ID], count(*)
FROM fn_dblog(NULL,NULL)
GROUP BY [Transaction ID]
ORDER BY count(*) DESC

select Operation, count(*) FROM fn_dblog(NULL,NULL) WHERE [Transaction ID] = '0000:000012c3'
GROUP BY Operation

/*
Now what happens when something like CDC gets thrown in the mix?
*/

-- Enable CDC
EXECUTE sys.sp_cdc_enable_db;  
GO  

-- enable CDC on Child
EXEC sys.sp_cdc_enable_table   
   @source_schema = N'dbo',
   @source_name   = N'Child',
   @role_name     = NULL,
   @filegroup_name = N'Primary',
   @supports_net_changes = 0
GO

UPDATE Parent SET Parent_Key = 'Parent CDC' WHERE Parent_Key = 'Parent 1'

/*
Let's do some CDC monitoring: (fromhttps://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/change-data-capture-sys-dm-cdc-log-scan-sessions?view=sql-server-ver15)
*/

SELECT session_id, start_time, end_time, duration, scan_phase,  
    error_count, start_lsn, current_lsn, end_lsn, tran_count,  
    last_commit_lsn, last_commit_time, log_record_count, schema_change_count,  
    command_count, first_begin_cdc_lsn, last_commit_cdc_lsn,   
    last_commit_cdc_time, latency, empty_scan_count, failed_sessions_count  
FROM sys.dm_cdc_log_scan_sessions ;


/*
Now let's check out our database and log size:
*/

SELECT name, size/1024 as SizeInMB FROM sys.database_files

SELECT [Transaction ID], count(*)
FROM fn_dblog(NULL,NULL)
GROUP BY [Transaction ID]
ORDER BY count(*) DESC

select Operation, count(*) FROM fn_dblog(NULL,NULL) WHERE [Transaction ID] = '0000:000034c1'
GROUP BY Operation

/*
So what does this mean for my cdc data?
*/

Select * FROM cdc.dbo_Child_CT

/*
Time to clean up
*/

-- Disable CDC
EXECUTE sys.sp_cdc_disable_db;  
GO  


USE [master]
GO
ALTER DATABASE [TLogGrowth_Test] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DROP DATABASE [TLogGrowth_Test]
GO
