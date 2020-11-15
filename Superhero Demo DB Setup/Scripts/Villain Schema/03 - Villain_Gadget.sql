USE Superheroes
GO

/* 
 * TABLE: Gadget 
 */

CREATE TABLE Villain.Gadget(
    Gadget_ID      int             IDENTITY(1,1),
    Gadget_Name    varchar(500)    NULL,
    Gadget_Desc    varchar(500)    NULL
)
go



IF OBJECT_ID('Gadget') IS NOT NULL
    PRINT '<<< CREATED TABLE Gadget >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Gadget >>>'
go


