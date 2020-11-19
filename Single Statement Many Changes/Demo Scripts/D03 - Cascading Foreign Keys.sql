USE Superheroes;
GO

/******************************
******************************
 Demo: Cascading Foreign Keys
******************************
******************************/

-- let's get rid of the trigger. Who thought this was a good idea??
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'Person_dtr')
DROP TRIGGER Person_dtr ;
GO

-- Let's put me back in the game:

INSERT INTO Person (First_Name, Last_Name)
VALUES ('Deborah', 'Melkin')

SELECT * 
FROM Person as p 
	JOIN Alter_Ego_Person as aep ON p.Person_ID = aep.Person_ID
WHERE p.Last_Name = 'Melkin'

-- Delete me 
-- but first, show the execution plan
DELETE p FROM Person as p
WHERE p.Last_Name = 'Melkin'


/* Replace DELETE Trigger on Person with a Cascading FOREIGN KEY ON Alter_Ego_Person */

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Person_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person DROP CONSTRAINT FK_Alter_Ego_Person_Person_ID
;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Person_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Person_ID
    FOREIGN KEY (Person_ID)
    REFERENCES Person(Person_ID)
	ON DELETE CASCADE
go

--- now - Delete Me
DELETE p FROM Person as p
WHERE p.Last_Name = 'Melkin'

SELECT * FROM Alter_Ego_Person

--- so what else can we do here...????

-- what happens if we delete an Alter Ego??
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person DROP CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
    FOREIGN KEY (Alter_Ego_ID)
    REFERENCES Alter_Ego(Alter_Ego_ID)
	ON DELETE SET DEFAULT 
go

-- modify the column
ALTER TABLE Alter_Ego_Person
ADD CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID DEFAULT 1
	FOR Alter_Ego_ID
;


-- now go back and modify the table....

-- Who needs to go...
SELECT * FROM Alter_Ego WHERE Alter_Ego_ID > 1
SELECT * FROM Person WHERE First_Name = 'Ororo' AND Last_Name = 'Munroe'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Ororo' AND Last_Name = 'Munroe') AND Alter_Ego_Name = 'Storm'

SELECT * FROM Alter_Ego_Person WHERE Alter_Ego_ID = 4

DELETE FROM Alter_Ego WHERE Alter_Ego_Name = 'Storm'

SELECT * FROM Alter_Ego_Person WHERE Person_ID = 7


-- Now - what happens if the default doesn't exist in the reference table?
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person DROP CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person DROP CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person
ADD CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID DEFAULT 0
	FOR Alter_Ego_ID
;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
    FOREIGN KEY (Alter_Ego_ID)
    REFERENCES Alter_Ego(Alter_Ego_ID)
	ON DELETE SET DEFAULT 
go


-- re-add storm in...
IF NOT EXISTS (SELECT * FROM Alter_Ego WHERE Alter_Ego_Name = 'Storm')
INSERT INTO Alter_Ego (Alter_Ego_Name, Comic_Universe_ID)
OUTPUT inserted.Alter_Ego_ID
SELECT 'Storm', Comic_Universe_ID
FROM Comic_Universe WHERE Comic_Universe_Name = 'Marvel'

SELECT * FROM Person

UPDATE Alter_Ego_Person
SET Alter_Ego_ID = 8
WHERE Person_ID = 7


DELETE FROM Alter_Ego WHERE Alter_Ego_Name = 'Storm'

SELECT * FROM Alter_Ego_Person WHERE Person_ID = 7
select * from Alter_Ego WHERE Alter_Ego_Name = 'Storm'

-- reset!
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person DROP CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person DROP CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person
ADD CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID DEFAULT 1
	FOR Alter_Ego_ID
;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
    FOREIGN KEY (Alter_Ego_ID)
    REFERENCES Alter_Ego(Alter_Ego_ID)
	ON DELETE SET DEFAULT 
go

/***************
 End of Script
***************/