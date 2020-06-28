-- Make sure I'm using the right database
USE tempdb
GO

-- Drop the tables
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'SalesOrder')
	DROP TABLE dbo.SalesOrder
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Account')
	DROP TABLE dbo.Account
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Person')
	DROP TABLE dbo.Person
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Currency')
	DROP TABLE dbo.Currency
GO
