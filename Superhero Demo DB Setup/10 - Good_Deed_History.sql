USE Superheroes
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Good_Deed_History')
CREATE TABLE dbo.Good_Deed_History (
	Good_Deed_History_ID INT IDENTITY(1, 1),
	Good_Deed_Type_ID TINYINT,
	Good_Deed_Person_ID INT,
	Good_Deed_Description VARCHAR(250),
	Good_Deed_Timestamp DATETIME DEFAULT(GETDATE()),
	CONSTRAINT PK_Good_Deed_History PRIMARY KEY CLUSTERED (Good_Deed_History_ID)
);
