USE Superheroes;
GO

/* 
 * TABLE: Alter_Ego_Person
 */

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Alter_Ego_Person')
 CREATE TABLE Alter_Ego_Person (
	Alter_Ego_Person_ID	int	IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Alter_Ego_Person PRIMARY KEY CLUSTERED,
	Person_ID			int	NOT NULL,
	Alter_Ego_ID		int NOT NULL,
	CONSTRAINT UQ_Alter_Ego_Person UNIQUE (Person_ID, Alter_Ego_ID)
	);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IDX_Alter_Ego_Person_Alter_Ego_ID')
CREATE INDEX IDX_Alter_Ego_Person_Alter_Ego_ID ON Alter_Ego_Person (Alter_Ego_ID);
GO