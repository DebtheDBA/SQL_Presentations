USE Superheroes
GO

/* 
 * TABLE: Corporation 
 */

CREATE TABLE Corporation(
    Corporation_ID      int            IDENTITY(1,1),
    Corporation_Name    varchar(50)    NOT NULL,
    CONSTRAINT PK_Corporation PRIMARY KEY CLUSTERED (Corporation_ID),
    CONSTRAINT AK_Corporation  UNIQUE (Corporation_Name)
)
go



IF OBJECT_ID('Corporation') IS NOT NULL
    PRINT '<<< CREATED TABLE Corporation >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Corporation >>>'
go

