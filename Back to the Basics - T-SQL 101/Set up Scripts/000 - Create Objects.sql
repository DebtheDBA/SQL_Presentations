-- Make sure I'm using the right database
USE tempdb
GO

-- if the tables are there, delete them
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'SalesOrder')
	DROP TABLE dbo.SalesOrder;
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Account')
	DROP TABLE dbo.Account;
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Person')
	DROP TABLE dbo.Person;
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Currency')
	DROP TABLE dbo.Currency;
GO


-- Create the dbo.Currency table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Currency')
CREATE TABLE dbo.Currency (
	Currency_ID	int IDENTITY(1,1)	NOT NULL
		CONSTRAINT PK_Currency PRIMARY KEY CLUSTERED ,
	Currency_Code	char(3)		NOT NULL
		CONSTRAINT UQ_Currency UNIQUE,
	Currency_Name	varchar(30)		NOT NULL,
	To_USD			numeric(10, 6)	NOT NULL,
	From_USD		numeric(10, 6)	NOT NULL
	);
GO


-- Create the dbo.Person table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Person')
CREATE TABLE dbo.Person (
	Person_ID	int	IDENTITY (1,1)	NOT NULL
		CONSTRAINT PK_Person PRIMARY KEY CLUSTERED,
	Full_Name	varchar(100)		NOT NULL,
	Last_Name	varchar(50)			NULL,
	First_Name	varchar(50)			NULL
	);
GO


-- Create the dbo.Account table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Account')
CREATE TABLE dbo.Account (
	Account_ID					int	IDENTITY(1,1)	NOT NULL
		CONSTRAINT PK_Account PRIMARY KEY CLUSTERED,
	Account_Name				varchar(100)		NOT NULL
		CONSTRAINT UQ_Account UNIQUE,
	Primary_Contact_Person_ID	int		NOT NULL
		CONSTRAINT FK_Account_Primary_Contact_Person FOREIGN KEY	
			REFERENCES dbo.Person (Person_ID),
	Alternate_Contact_Person_ID	int		NULL
		CONSTRAINT FK_Account_Alt_Contact_Person FOREIGN KEY
			REFERENCES dbo.Person (Person_ID)
	);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Account_Primary_Contact_Person_ID')
CREATE INDEX IX_Account_Primary_Contact_Person_ID ON dbo.Account (Primary_Contact_Person_ID);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Account_Alt_Contact_Person_ID')
CREATE INDEX IX_Account_Alt_Contact_Person_ID ON dbo.Account (Alternate_Contact_Person_ID);
GO

-- Create the Orders table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'SalesOrder')
CREATE TABLE dbo.SalesOrder (
	Sales_Order_ID		int	IDENTITY(1,1)	NOT NULL
		CONSTRAINT PK_SalesOrder PRIMARY KEY CLUSTERED,
	Account_ID			int					NOT NULL
		CONSTRAINT FK_SalesOrder_Account FOREIGN KEY
			REFERENCES dbo.Account (Account_ID),
	Contact_Person_ID	int					NOT NULL
		CONSTRAINT FK_SalesOrder_Person FOREIGN KEY
			REFERENCES dbo.Person (Person_ID),
	Total_Amount		numeric(10, 2)		NOT NULL,
	Amount_Due			numeric(10, 2)		NOT NULL,
	Last_Updated		datetime			NOT NULL
	);
GO
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SalesOrder_Account_ID')
CREATE INDEX IX_SalesOrder_Account_ID ON dbo.SalesOrder (Account_ID);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SalesOrder_Contact_Person_ID')
CREATE INDEX IX_SalesOrder_Contact_Person_ID ON dbo.SalesOrder (Contact_Person_ID);
GO
