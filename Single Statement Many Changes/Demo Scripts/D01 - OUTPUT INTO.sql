USE Superheroes;
GO

/******************************
******************************
 Demo: OUTPUT 
******************************
******************************/

-- What data do I have to start with??
SELECT * FROM dbo.Comic_Universe

SELECT * FROM dbo.Alter_Ego

SELECT * FROM dbo.Person

-- add my list of people

INSERT INTO dbo.Person (First_Name, Last_Name)
	OUTPUT inserted.Person_ID, 1
	INTO dbo.Alter_Ego_Person (Person_ID, Alter_Ego_ID)
VALUES	('Deborah', 'Melkin'),
		('Diana', 'Prince'),	
		('Linda','Danvers'),	
		('Selina', 'Kyle'),		
		('May', 'Parker'),		
		('Natasha', 'Romanoff'),
		('Ororo', 'Munroe')		
;

-------------------------------------------------------------------------
-- D'oh - can't do it this way because of the foreign keys on the table.
-- We'll come back to this.....
-------------------------------------------------------------------------

INSERT INTO dbo.Person (First_Name, Last_Name)
VALUES	('Deborah', 'Melkin'),
		('Diana', 'Prince'),	
		('Linda','Danvers'),	
		('Selina', 'Kyle'),		
		('May', 'Parker'),		
		('Natasha', 'Romanoff'),
		('Ororo', 'Munroe')		
;


INSERT INTO dbo.Alter_Ego_Person (Person_ID, Alter_Ego_ID)
	OUTPUT 'I', inserted.Person_ID, inserted.Alter_Ego_ID
	INTO dbo.Alter_Ego_Person_History (ChangeType, New_Person_ID, New_Alter_Ego_ID)
SELECT p.Person_ID, ae.Alter_Ego_ID
FROM dbo.Person	as p
	CROSS JOIN dbo.Alter_Ego as ae
WHERE ae.Alter_Ego_Name = 'Average Citizen'


SELECT * FROM dbo.Alter_Ego_Person
SELECT * FROM dbo.Alter_Ego_Person_History


-------------------------------------------------------------------------
--- I'm no Average Citizen, I'm Wonder Woman
-------------------------------------------------------------------------
SELECT *
FROM dbo.Person as p
	CROSS JOIN dbo.Alter_Ego as ae
WHERE p.Last_Name = 'Melkin'
AND ae.Alter_Ego_Name = 'Wonder Woman'


UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
	OUTPUT 'U', inserted.Person_ID, inserted.Alter_Ego_ID, deleted.Person_ID, deleted.Alter_Ego_ID
	INTO dbo.Alter_Ego_Person_History (ChangeType, New_Person_ID, New_Alter_Ego_ID, Old_Person_ID, Old_Alter_Ego_ID)
FROM dbo.Person as p
	JOIN dbo.Alter_Ego_Person as aep ON p.Person_ID = aep.Person_ID
	CROSS JOIN dbo.Alter_Ego as ae
WHERE p.Last_Name = 'Melkin'
AND ae.Alter_Ego_Name = 'Wonder Woman'


SELECT * FROM dbo.Alter_Ego_Person
SELECT * FROM dbo.Alter_Ego_Person_History


-------------------------------------------------------------------------
-- what do you mean I don't belong here????
-------------------------------------------------------------------------
DELETE aep
	OUTPUT 'D', deleted.Person_ID, deleted.Alter_Ego_ID
	INTO dbo.Alter_Ego_Person_History (ChangeType, Old_Person_ID, Old_Alter_Ego_ID)
FROM dbo.Alter_Ego_Person as aep
	JOIN dbo.Person as p ON aep.Person_ID = p.Person_ID
WHERE p.Last_Name = 'Melkin'

SELECT * FROM dbo.Alter_Ego_Person
SELECT * FROM dbo.Alter_Ego_Person_History

GO

/***************
 End of Script
***************/