USE Superheroes;
GO

/* 
 * TABLE: Alter_Ego 
 */

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Comic_Universe' AND parent_object_id = OBJECT_ID('Alter_Ego'))
ALTER TABLE Alter_Ego ADD CONSTRAINT FK_Alter_Ego_Comic_Universe 
    FOREIGN KEY (Comic_Universe_ID)
    REFERENCES Comic_Universe(Comic_Universe_ID)
go

