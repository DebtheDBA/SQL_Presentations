USE Superheroes;
GO

/* 
 * TABLE: Alter_Ego 
 */

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Alter_Ego')
CREATE TABLE Alter_Ego(
    Alter_Ego_ID         int            IDENTITY(1,1)
		CONSTRAINT PK_Alter_Ego PRIMARY KEY CLUSTERED ,
    Alter_Ego_Name       varchar(50)    NOT NULL
	    CONSTRAINT AK_Alter_Ego  UNIQUE (Alter_Ego_Name),
    Comic_Universe_ID    int            NOT NULL
);
go



IF OBJECT_ID('Alter_Ego') IS NOT NULL
    PRINT '<<< CREATED TABLE Alter_Ego >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Alter_Ego >>>'
go

/* 
 * INDEX: FK_Alter_Ego_Comic_Universe 
 */

CREATE INDEX FK_Alter_Ego_Comic_Universe ON Alter_Ego(Comic_Universe_ID)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Alter_Ego') AND name='FK_Alter_Ego_Comic_Universe')
    PRINT '<<< CREATED INDEX Alter_Ego.FK_Alter_Ego_Comic_Universe >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Alter_Ego.FK_Alter_Ego_Comic_Universe >>>'
go

