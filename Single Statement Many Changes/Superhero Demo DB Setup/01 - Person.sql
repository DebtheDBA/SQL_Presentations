USE Superheroes;
GO

/* 
 * TABLE: Person 
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Person')
CREATE TABLE Person(
    Person_ID     int            IDENTITY(1,1),
    First_Name    varchar(50)    NOT NULL,
    Last_Name     varchar(50)    NOT NULL,
    CONSTRAINT PK_Person PRIMARY KEY CLUSTERED (Person_ID)
);
go



IF OBJECT_ID('Person') IS NOT NULL
    PRINT '<<< CREATED TABLE Person >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Person >>>'
go

