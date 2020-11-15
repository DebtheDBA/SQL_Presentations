USE Superheroes
GO

/* 
 * TABLE: Villain.Gadget_Order_Form 
 */
DROP TABLE IF EXISTS Villain.Gadget_Order_Form
GO

CREATE TABLE Villain.Gadget_Order_Form(
    Order_ID          int         IDENTITY(1,1),
    Order_Date        datetime		NOT NULL
		CONSTRAINT DF_Villain_Gadget_Order_Form_Order_Date DEFAULT getdate(),
    Person_ID         int			NULL,
    Corporation_ID    int			NULL,
	Gadget_ID		  varchar(100)  NULL,
	Number_Ordered	  float			NULL,		
	Price_Per_Item	  float			NULL,
	Tax               money			NULL,
    Shipping          money			NULL,
    Total_Due         int			NULL,
    CONSTRAINT PK_Villain_Gadget_Order_Form PRIMARY KEY CLUSTERED (Order_ID)
)
go