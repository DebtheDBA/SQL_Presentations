USE Superheroes;
GO

/* 
 * TABLE: Alter_Ego_Person_History
 */

CREATE TABLE Alter_Ego_Person_History(
	Alter_Ego_Person_History_ID	int			IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Alter_Ego_Person_History PRIMARY KEY CLUSTERED,
	History_Date		 datetime		NOT NULL
		CONSTRAINT DF_Alter_Ego_Person_History_History_Date DEFAULT getdate(),
	ChangeType			 char(1)		NOT NULL,	-- values: I\U\D
    Old_Alter_Ego_ID     int            NULL,
    Old_Person_ID        int            NULL,
    New_Alter_Ego_ID     int            NULL,
    New_Person_ID        int            NULL,
	CONSTRAINT UQ_Alter_Ego_Person_History UNIQUE (History_Date, ChangeType, Old_Alter_Ego_ID, Old_Person_ID, New_Alter_Ego_ID, New_Person_ID)
	);
GO

IF OBJECT_ID('Alter_Ego_Person_History') IS NOT NULL
    PRINT '<<< CREATED TABLE Alter_Ego_Person_History >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Alter_Ego_Person_History >>>'
go

