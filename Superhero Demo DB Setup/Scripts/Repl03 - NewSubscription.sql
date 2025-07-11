/******
NOTE: 
This script could still work but you have to make sure you update for your set up.

OR you could skip the scripts that start with REPL01, REPL02 and REPL03 
and use the PowerShell script, Setup_Replication.ps1 instead. 

Highly recommend the PowerShell script route ...

******/

-----------------BEGIN: Script to be run at Publisher 'DEBTHEDBA\SQL2019'-----------------
USE [Superheroes]
EXEC sp_addsubscription @publication = N'Superhero_Repl',
		@subscriber = @@servername,
		@destination_db = N'Superheroes_Repl',
		@subscription_type = N'Push',
		@sync_type = N'automatic',
		@article = N'all',
		@update_mode = N'read only',
		@subscriber_type = 0


exec sp_addpushsubscription_agent @publication = N'Superhero_Repl',
		@subscriber = @@servername,
		@subscriber_db = N'Superheroes_Repl',
		@job_login = null,
		@job_password = null,
		@subscriber_security_mode = 1,
		@frequency_type = 64,
		@frequency_interval = 0,
		@frequency_relative_interval = 0,
		@frequency_recurrence_factor = 0,
		@frequency_subday = 0,
		@frequency_subday_interval = 0,
		@active_start_time_of_day = 0,
		@active_end_time_of_day = 235959,
		@active_start_date = 20200224,
		@active_end_date = 99991231,
		@enabled_for_syncmgr = N'False',
		@dts_package_location = N'Distributor'
GO
-----------------END: Script to be run at Publisher 'DEBTHEDBA\SQL2019'-----------------

