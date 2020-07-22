USE Superheroes;
GO

/******************************
******************************
 Demo: OUTPUT 
******************************
******************************/

-- What data do I have to start with??
SELECT * FROM Comic_Universe

SELECT * FROM Alter_Ego

SELECT * FROM Person

-- add my list of people

INSERT INTO Person (First_Name, Last_Name)
OUTPUT inserted.Person_ID, 1
INTO Alter_Ego_Person (Person_ID, Alter_Ego_ID)
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

INSERT INTO Person (First_Name, Last_Name)
VALUES	('Deborah', 'Melkin'),
		('Diana', 'Prince'),	
		('Linda','Danvers'),	
		('Selina', 'Kyle'),		
		('May', 'Parker'),		
		('Natasha', 'Romanoff'),
		('Ororo', 'Munroe')		
;


INSERT INTO Alter_Ego_Person
	OUTPUT 'I', inserted.Person_ID, inserted.Alter_Ego_ID
	INTO Alter_Ego_Person_History (ChangeType, New_Person_ID, New_Alter_Ego_ID)
SELECT p.Person_ID, ae.Alter_Ego_ID
FROM Person	as p
	CROSS JOIN Alter_Ego as ae
WHERE ae.Alter_Ego_Name = 'Average Citizen'


select * from Alter_Ego_Person
select * from Alter_Ego_Person_History

--- I'm no Average Citizen, I'm Wonder Woman
SELECT *
FROM Person as p
	CROSS JOIN Alter_Ego as ae
WHERE p.Last_Name = 'Melkin'
AND ae.Alter_Ego_Name = 'Wonder Woman'


UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
	OUTPUT 'U', inserted.Person_ID, inserted.Alter_Ego_ID, deleted.Person_ID, deleted.Alter_Ego_ID
	INTO Alter_Ego_Person_History (ChangeType, New_Person_ID, New_Alter_Ego_ID, Old_Person_ID, Old_Alter_Ego_ID)
FROM Person as p
	JOIN Alter_Ego_Person as aep ON p.Person_ID = aep.Person_ID
	CROSS JOIN Alter_Ego as ae
WHERE p.Last_Name = 'Melkin'
AND ae.Alter_Ego_Name = 'Wonder Woman'


select * from Alter_Ego_Person
select * from Alter_Ego_Person_History

-- what do you mean I don't belong here????

DELETE aep
	OUTPUT 'D', deleted.Person_ID, deleted.Alter_Ego_ID
	INTO Alter_Ego_Person_History (ChangeType, Old_Person_ID, Old_Alter_Ego_ID)
FROM Alter_Ego_Person as aep
	JOIN Person as p ON aep.Person_ID = p.Person_ID
WHERE p.Last_Name = 'Melkin'

select * from Alter_Ego_Person
select * from Alter_Ego_Person_History

GO

/***************
 End of Script
***************/