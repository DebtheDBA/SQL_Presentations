/******
NOTE: 
This script could still work but you have to make sure you update for your set up.

OR you could skip the scripts that start with REPL01, REPL02 and REPL03 
and use the PowerShell script, Setup_Replication.ps1 instead. 

Highly recommend the PowerShell script route ...

******/

USE [Superheroes]
EXEC sp_replicationdboption @dbname = N'Superheroes',
		@optname = N'publish',
		@value = N'true'
GO
-- Adding the transactional publication
USE [Superheroes]
EXEC sp_addpublication @publication = N'Superhero_Repl',
		@description = N'Transactional publication of database ''Superheroes'' from Publisher ''DebTheDBA\SQL2019''.',
		@sync_method = N'concurrent',
		@retention = 0,
		@allow_push = N'true',
		@allow_pull = N'true',
		@allow_anonymous = N'true',
		@enabled_for_internet = N'false',
		@snapshot_in_defaultfolder = N'true',
		@compress_snapshot = N'false',
		@ftp_port = 21,
		@ftp_login = N'anonymous',
		@allow_subscription_copy = N'false',
		@add_to_active_directory = N'false',
		@repl_freq = N'continuous',
		@status = N'active',
		@independent_agent = N'true',
		@immediate_sync = N'true',
		@allow_sync_tran = N'false',
		@autogen_sync_procs = N'false',
		@allow_queued_tran = N'false',
		@allow_dts = N'false',
		@replicate_ddl = 1,
		@allow_initialize_from_backup = N'false',
		@enabled_for_p2p = N'false',
		@enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'Superhero_Repl',
		@frequency_type = 1,
		@frequency_interval = 0,
		@frequency_relative_interval = 0,
		@frequency_recurrence_factor = 0,
		@frequency_subday = 0,
		@frequency_subday_interval = 0,
		@active_start_time_of_day = 0,
		@active_end_time_of_day = 235959,
		@active_start_date = 0,
		@active_end_date = 0,
		@job_login = null,
		@job_password = null,
		@publisher_security_mode = 1


use [Superheroes]
exec sp_addarticle @publication = N'Superhero_Repl',
		@article = N'Alter_Ego',
		@source_owner = N'dbo',
		@source_object = N'Alter_Ego',
		@type = N'logbased',
		@description = null,
		@creation_script = null,
		@pre_creation_cmd = N'drop',
		@schema_option = 0x00000000080358DF,
		@identityrangemanagementoption = N'manual',
		@destination_table = N'Alter_Ego',
		@destination_owner = N'dbo',
		@vertical_partition = N'false',
		@ins_cmd = N'CALL sp_MSins_dboAlter_Ego',
		@del_cmd = N'CALL sp_MSdel_dboAlter_Ego',
		@upd_cmd = N'SCALL sp_MSupd_dboAlter_Ego'
GO




use [Superheroes]
exec sp_addarticle @publication = N'Superhero_Repl',
		@article = N'Alter_Ego_Person',
		@source_owner = N'dbo',
		@source_object = N'Alter_Ego_Person',
		@type = N'logbased',
		@description = null,
		@creation_script = null,
		@pre_creation_cmd = N'drop',
		@schema_option = 0x00000000080358DF,
		@identityrangemanagementoption = N'manual',
		@destination_table = N'Alter_Ego_Person',
		@destination_owner = N'dbo',
		@vertical_partition = N'false',
		@ins_cmd = N'CALL sp_MSins_dboAlter_Ego_Person',
		@del_cmd = N'CALL sp_MSdel_dboAlter_Ego_Person',
		@upd_cmd = N'SCALL sp_MSupd_dboAlter_Ego_Person'
GO




use [Superheroes]
exec sp_addarticle @publication = N'Superhero_Repl',
		@article = N'Alter_Ego_Person_History',
		@source_owner = N'dbo',
		@source_object = N'Alter_Ego_Person_History',
		@type = N'logbased',
		@description = null,
		@creation_script = null,
		@pre_creation_cmd = N'drop',
		@schema_option = 0x00000000080358DF,
		@identityrangemanagementoption = N'manual',
		@destination_table = N'Alter_Ego_Person_History',
		@destination_owner = N'dbo',
		@vertical_partition = N'false',
		@ins_cmd = N'CALL sp_MSins_dboAlter_Ego_Person_History',
		@del_cmd = N'CALL sp_MSdel_dboAlter_Ego_Person_History',
		@upd_cmd = N'SCALL sp_MSupd_dboAlter_Ego_Person_History'
GO




use [Superheroes]
exec sp_addarticle @publication = N'Superhero_Repl',
		@article = N'Comic_Universe',
		@source_owner = N'dbo',
		@source_object = N'Comic_Universe',
		@type = N'logbased',
		@description = null,
		@creation_script = null,
		@pre_creation_cmd = N'drop',
		@schema_option = 0x00000000080358DF,
		@identityrangemanagementoption = N'manual',
		@destination_table = N'Comic_Universe',
		@destination_owner = N'dbo',
		@vertical_partition = N'false',
		@ins_cmd = N'CALL sp_MSins_dboComic_Universe',
		@del_cmd = N'CALL sp_MSdel_dboComic_Universe',
		@upd_cmd = N'SCALL sp_MSupd_dboComic_Universe'
GO




use [Superheroes]
exec sp_addarticle @publication = N'Superhero_Repl',
		@article = N'Person',
		@source_owner = N'dbo',
		@source_object = N'Person',
		@type = N'logbased',
		@description = null,
		@creation_script = null,
		@pre_creation_cmd = N'drop',
		@schema_option = 0x00000000080358DF,
		@identityrangemanagementoption = N'manual',
		@destination_table = N'Person',
		@destination_owner = N'dbo',
		@vertical_partition = N'false',
		@ins_cmd = N'CALL sp_MSins_dboPerson',
		@del_cmd = N'CALL sp_MSdel_dboPerson',
		@upd_cmd = N'SCALL sp_MSupd_dboPerson'
GO

PRINT 'START THE SNAPSHOT NOW!!!!'

SELECT 'START THE SNAPSHOT NOW!!!!'



