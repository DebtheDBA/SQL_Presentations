use Superheroes
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Gadget_Order_Form_Corporation' AND parent_object_id = OBJECT_ID('Gadget_Order_Form'))
ALTER TABLE Gadget_Order_Form ADD CONSTRAINT FK_Gadget_Order_Form_Corporation 
    FOREIGN KEY (Corporation_ID)
    REFERENCES Corporation(Corporation_ID)
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Gadget_Order_Form_Person' AND parent_object_id = OBJECT_ID('Gadget_Order_Form'))
ALTER TABLE Gadget_Order_Form ADD CONSTRAINT FK_Gadget_Order_Form_Person 
    FOREIGN KEY (Person_ID)
    REFERENCES Person(Person_ID)
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Gadget_Order_Form_Gadget' AND parent_object_id = OBJECT_ID('Gadget_Order_Form'))
ALTER TABLE Gadget_Order_Form ADD CONSTRAINT FK_Gadget_Order_Form_Gadget 
    FOREIGN KEY (Gadget_ID)
    REFERENCES Gadget(Gadget_ID)
go
