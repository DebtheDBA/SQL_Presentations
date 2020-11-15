USE Superheroes
GO

/* 
 * TABLE: Gadget_Order_Form 
 */

CREATE TABLE dbo.Gadget_Order_Form(
    Order_ID          int				IDENTITY(1,1) NOT NULL,
    Order_Date        datetime			NOT NULL
		CONSTRAINT DF_Gadget_Order_Form_Order_Date DEFAULT getdate(),
    Person_ID         int				NOT NULL,
    Corporation_ID    int				NULL,
	Gadget_ID		  int				NOT NULL,
	Number_Ordered	  int				NOT NULL
		CONSTRAINT CK_Gadget_Order_Form_Number_Ordered CHECK (Number_Ordered >= 0 AND Number_Ordered < 10000),		
	Price_Per_Item	  numeric(19, 2)	NOT NULL
		CONSTRAINT DF_Gadget_Order_Form_Price_Per_Item DEFAULT 0,
	Tax               numeric(19, 2)    NOT NULL
		CONSTRAINT DF_Gadget_Order_Form_Tax DEFAULT 0,
    Shipping          numeric(19, 2)    NOT NULL
		CONSTRAINT DF_Gadget_Order_Form_Shipping DEFAULT 0,
    Total_Due         numeric(19, 2)    NOT NULL
		CONSTRAINT DF_Gadget_Order_Form_TotalDue DEFAULT 0,
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
 * INDEX: IX_Gadget_Order_Form_Person 
 */

CREATE INDEX IX_Gadget_Order_Form_Person ON Gadget_Order_Form(Person_ID)
go

/* 
 * INDEX: IX_Gadget_Order_Form_Corporation 
 */

CREATE INDEX IX_Gadget_Order_Form_Corporation ON Gadget_Order_Form(Corporation_ID)
go

/* 
 * INDEX: IX_Gadget_Order_Form_Gadget 
 */

CREATE INDEX IX_Gadget_Order_Form_Gadget ON Gadget_Order_Form(Gadget_ID)
go
