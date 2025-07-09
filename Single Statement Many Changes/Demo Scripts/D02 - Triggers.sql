USE Superheroes;
GO

/******************************
******************************
 Demo: TRIGGERS 
******************************
******************************/

-- Everytime we want to insert a Person, we want to add them to the Alter_Ego_Person table
CREATE OR ALTER TRIGGER Person_itr ON dbo.Person
FOR INSERT
AS
BEGIN

	INSERT INTO dbo.Alter_Ego_Person (Person_ID, Alter_Ego_ID)
		OUTPUT 'I', inserted.Person_ID, inserted.Alter_Ego_ID
		INTO dbo.Alter_Ego_Person_History (ChangeType, New_Person_ID, New_Alter_Ego_ID)
	SELECT p.Person_ID, ae.Alter_Ego_ID
	FROM inserted	as p
		CROSS JOIN dbo.Alter_Ego as ae
	WHERE ae.Alter_Ego_Name = 'Average Citizen'
	
END
GO

-- show the estimated plan before running the next statement
-- run with execution plan on (Ctrl + M)
INSERT INTO dbo.Person (First_Name, Last_Name)
VALUES ('Deborah', 'Melkin')
;
GO

-- Confirm I'm in the Person and Alter_Ego_Person tables
SELECT *
FROM dbo.Person as p
	JOIN dbo.Alter_Ego_Person as aep ON p.Person_ID = aep.Person_ID
WHERE p.Last_Name = 'Melkin';
GO


-------------------------------------------------------------------------
-- When we delete a Person, we need to remove them to the Alter_Ego_Person table
-------------------------------------------------------------------------
CREATE OR ALTER TRIGGER Person_dtr ON dbo.Person
FOR DELETE
AS
BEGIN

	DELETE aep
		OUTPUT 'D', deleted.Person_ID, deleted.Alter_Ego_ID
		INTO dbo.Alter_Ego_Person_History (ChangeType, Old_Person_ID, Old_Alter_Ego_ID)
	FROM dbo.Alter_Ego_Person as aep
		JOIN deleted as p ON aep.Person_ID = p.Person_ID
	
END
GO

DELETE FROM dbo.Person
WHERE Last_Name = 'Melkin'
;
GO



-------------------------------------------------------------------------
-- let's recreate that delete trigger:
-------------------------------------------------------------------------

CREATE OR ALTER TRIGGER Person_dtr ON dbo.Person
INSTEAD OF DELETE
AS
BEGIN

	DELETE aep
		OUTPUT 'D', deleted.Person_ID, deleted.Alter_Ego_ID
		INTO dbo.Alter_Ego_Person_History (ChangeType, Old_Person_ID, Old_Alter_Ego_ID)
	FROM dbo.Alter_Ego_Person as aep
		JOIN deleted as p ON aep.Person_ID = p.Person_ID
	
	DELETE p FROM dbo.Person as p JOIN deleted as d ON p.Person_ID = d.Person_ID
END
GO



DELETE FROM dbo.Person
WHERE Last_Name = 'Melkin'
;
GO

SELECT * FROM dbo.Person
SELECT * FROM dbo.Alter_Ego_Person
SELECT * FROM dbo.Alter_Ego_Person_History


/***************
 End of Script
***************/