USE Superheroes;
GO

/* 
 * TABLE: Comic_Universe 
 */
 IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Comic_Universe')
CREATE TABLE Comic_Universe(
    Comic_Universe_ID      int            IDENTITY(1,1),
    Comic_Universe_Name    varchar(50)    NOT NULL,
    CONSTRAINT PK_Comic_Universe PRIMARY KEY CLUSTERED (Comic_Universe_ID),
    CONSTRAINT AK_Comic_Universe  UNIQUE (Comic_Universe_Name)
);
go



IF OBJECT_ID('Comic_Universe') IS NOT NULL
    PRINT '<<< CREATED TABLE Comic_Universe >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Comic_Universe >>>'
go

