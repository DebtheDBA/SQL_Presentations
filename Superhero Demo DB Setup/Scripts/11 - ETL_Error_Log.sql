USE Superheroes
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'ETL_Error_Log')
CREATE TABLE dbo.ETL_Error_Log (
	ETL_Error_Log_ID INT IDENTITY(1, 1),
	Error_Description VARCHAR(500),
	CSV_Data VARCHAR(1000),
	Error_Timestamp DATETIME DEFAULT(GETDATE()),
	CONSTRAINT PK_ETL_Error_Log PRIMARY KEY CLUSTERED (ETL_Error_Log_ID)
);
