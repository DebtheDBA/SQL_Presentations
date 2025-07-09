USE Superheroes_Repl
GO

DROP TABLE IF EXISTS dbo.Trigger_Replication_Log;
GO

CREATE TABLE dbo.Trigger_Replication_Log (
	LogID INT IDENTITY(1,1) 
		CONSTRAINT PK_Trigger_Replication_Log PRIMARY KEY CLUSTERED,
	LogTime DATETIME NOT NULL
		CONSTRAINT DF_Trigger_Replication_Log_LogTime DEFAULT GETDATE(),
	LogMessage VARCHAR(50) NOT NULL
	)
;
GO

SELECT * FROM dbo.Trigger_Replication_Log