/******
NOTE: 
This script could still work but you have to make sure you update for your set up.

OR you could skip the scripts that start with REPL01, REPL02 and REPL03 
and use the PowerShell script, Setup_Replication.ps1 instead. 

Highly recommend the PowerShell script route ...

******/

/****** Scripting replication configuration. Script Date: 2/24/2020 7:31:13 PM ******/
/****** Please Note: For security reasons,
		all password parameters were scripted with either NULL or an empty string. ******/

/****** Installing the server as a Distributor. Script Date: 2/24/2020 7:31:13 PM ******/
USE master

DECLARE @servername sysname = @@servername

EXEC sp_adddistributor @distributor = @servername,
		@password = N''
GO



EXEC sp_adddistributiondb @database = N'distribution',
		@data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\',
		@log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\',		@log_file_size = 2,
		@min_distretention = 0,
		@max_distretention = 72,
		@history_retention = 48,
		@deletebatchsize_xact = 5000,
		@deletebatchsize_cmd = 2000,
		@security_mode = 1
GO

use [distribution] 

if (not exists (select * from sysobjects where name = 'UIProperties' and type = 'U ')) 
	create table UIProperties(id int) 
if (exists (select * from ::fn_listextendedproperty('SnapshotFolder',
		'user',
		'dbo',
		'table',
		'UIProperties',
		null,
		null))) 
	EXEC sp_updateextendedproperty N'SnapshotFolder',
		N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\ReplData',
		'user',
		dbo,
		'table',
		'UIProperties' 
else 
	EXEC sp_addextendedproperty N'SnapshotFolder',
		N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\ReplData',
		'user',
		dbo,
		'table',
		'UIProperties'
GO

exec sp_adddistpublisher @publisher = @@servername,
		@distribution_db = N'distribution',
		@security_mode = 1,
		@working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\ReplData',
		@trusted = N'false',
		@thirdparty_flag = 0,
		@publisher_type = N'MSSQLSERVER'
GO
