/* Options for the following trace were selected by "Deb the DBA" 
	(debthedba.wordpress.com) */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS 
	(SELECT *
     FROM sys.server_event_sessions    -- If Microsoft SQL Server.
     WHERE name = 'Superheroes_Repl_Trace'
	 )
CREATE EVENT SESSION [Superheroes_Repl_Trace] ON SERVER 
ADD EVENT sqlserver.existing_connection(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.lock_deadlock(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.lock_deadlock_chain(
	ACTION (sqlserver.database_id,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.rpc_completed(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.rpc_starting(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.sp_statement_completed(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.sp_statement_starting(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.sql_batch_completed(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.sql_batch_starting(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.sql_statement_completed(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl')),
ADD EVENT sqlserver.sql_statement_starting(
	ACTION (sqlserver.client_app_name,
			sqlserver.database_id,
			sqlserver.server_principal_name,
			sqlserver.session_id)
	WHERE ([sqlserver].[database_name]=N'Superheroes_Repl'))
ADD TARGET package0.event_file(SET filename=N'C:\GitRepo\SQL_Presentations\Superhero DBs Setup\XETrace\Superheroes_Repl_Trace',max_file_size=(100))

GO

-- start the session 
ALTER EVENT SESSION [Superheroes_Repl_Trace] ON SERVER  
STATE = start;  
GO  


/* -- stop the session
ALTER EVENT SESSION [Superheroes_Repl_Trace] ON SERVER  
STATE = stop;  
GO  
*/