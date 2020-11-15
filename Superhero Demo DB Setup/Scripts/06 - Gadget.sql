USE Superheroes
GO

/* 
 * TABLE: Gadget 
 */

CREATE TABLE Gadget(
    Gadget_ID      int             IDENTITY(1,1),
    Gadget_Name    varchar(50)     NOT NULL,
    Gadget_Desc    varchar(254)    NULL,
    CONSTRAINT PK_Gadget PRIMARY KEY CLUSTERED (Gadget_ID),
	CONSTRAINT AK_Gadget UNIQUE (Gadget_Name)
)
go



IF OBJECT_ID('Gadget') IS NOT NULL
    PRINT '<<< CREATED TABLE Gadget >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Gadget >>>'
go


