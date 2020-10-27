USE Superheroes
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Good_Deed_Type')
CREATE TABLE dbo.Good_Deed_Type (
	Good_Deed_Type_ID TINYINT IDENTITY(1, 1),
	Good_Deed_Type_Name VARCHAR(50),
	CONSTRAINT PK_Good_Deed_Type PRIMARY KEY CLUSTERED (Good_Deed_Type_ID)

	
);