USE Superheroes
GO

/* 
 * TABLE: Gadget_Order_Form 
 */

CREATE TABLE Gadget_Order_Form(
    Order_ID          int         IDENTITY(1,1),
    Order_Date        datetime    NOT NULL
		CONSTRAINT DF_Gadget_Order_Form_Order_Date DEFAULT getdate(),
    Person_ID         int         NOT NULL,
    Corporation_ID    int         NULL,
	Gadget_ID		  int		  NULL,
	Number_Ordered	  int		  NULL,		
	Price_Per_Item	  money		  NULL,
	Tax               money       NULL,
    Shipping          money       NULL,
    Total_Due         money       NULL,
    CONSTRAINT PK_Gadget_Order_Form PRIMARY KEY CLUSTERED (Order_ID),
	CONSTRAINT UQ_Gadget_Order_Form UNIQUE (Order_Date, Person_ID, Corporation_ID, Gadget_ID)
)
go

IF OBJECT_ID('Gadget_Order_Form') IS NOT NULL
    PRINT '<<< CREATED TABLE Gadget_Order_Form >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Gadget_Order_Form >>>'
go

/* 
 * INDEX: FK_Gadget_Order_Form_Person 
 */

CREATE INDEX FK_Gadget_Order_Form_Person ON Gadget_Order_Form(Person_ID)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gadget_Order_Form') AND name='FK_Gadget_Order_Form_Person')
    PRINT '<<< CREATED INDEX Gadget_Order_Form.FK_Gadget_Order_Form_Person >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gadget_Order_Form.FK_Gadget_Order_Form_Person >>>'
go

/* 
 * INDEX: FK_Gadget_Order_Form_Corporation 
 */

CREATE INDEX FK_Gadget_Order_Form_Corporation ON Gadget_Order_Form(Corporation_ID)
go
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Gadget_Order_Form') AND name='FK_Gadget_Order_Form_Corporation')
    PRINT '<<< CREATED INDEX Gadget_Order_Form.FK_Gadget_Order_Form_Corporation >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Gadget_Order_Form.FK_Gadget_Order_Form_Corporation >>>'
go


CREATE INDEX FK_Gadget_Order_Form_Gadget ON Gadget_Order_Form(Gadget_ID)
go
