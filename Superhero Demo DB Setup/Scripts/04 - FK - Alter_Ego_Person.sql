USE Superheroes;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Person_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Person_ID
    FOREIGN KEY (Person_ID)
    REFERENCES Person(Person_ID)
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
    FOREIGN KEY (Alter_Ego_ID)
    REFERENCES Alter_Ego(Alter_Ego_ID)
go