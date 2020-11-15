USE Superheroes
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE Name = 'Villain')
	EXEC sp_executesql N'CREATE SCHEMA Villain'

GO
