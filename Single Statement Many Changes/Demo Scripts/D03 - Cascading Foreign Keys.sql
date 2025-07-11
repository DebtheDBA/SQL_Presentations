USE Superheroes;
GO

/******************************
******************************
 Demo: Cascading Foreign Keys
******************************
******************************/

-- let's get rid of the trigger. Who thought this was a good idea??
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'Person_dtr')
DROP TRIGGER dbo.Person_dtr ;
GO

-- Let's put me back in the game:

INSERT INTO dbo.Person (First_Name, Last_Name)
VALUES ('Deborah', 'Melkin')

SELECT * 
FROM dbo.Person as p 
	JOIN dbo.Alter_Ego_Person as aep ON p.Person_ID = aep.Person_ID
WHERE p.Last_Name = 'Melkin'

-- Delete me 
-- but first, show the execution plan
DELETE p FROM dbo.Person as p
WHERE p.Last_Name = 'Melkin'


-- why those extra tables?
SELECT OBJECT_NAME(parent_object_id) AS FK_RefTable, 
	name AS FK_name,
	OBJECT_NAME(referenced_object_id) AS FK_RefTable,
	delete_referential_action_desc,
	update_referential_action_desc, *
FROM sys.foreign_keys 
WHERE OBJECT_NAME(referenced_object_id) = 'Person'

-------------------------------------------------------------------------
/* Replace DELETE Trigger on dbo.Person with a Cascading FOREIGN KEY ON dbo.Alter_Ego_Person */
-------------------------------------------------------------------------


IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'FK_Alter_Ego_Person_Person_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    DROP CONSTRAINT FK_Alter_Ego_Person_Person_ID
;

IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'FK_Alter_Ego_Person_Person_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    ADD CONSTRAINT FK_Alter_Ego_Person_Person_ID
        FOREIGN KEY (Person_ID)
        REFERENCES dbo.Person (Person_ID) ON DELETE CASCADE;
GO

--- now - Delete Me
DELETE p FROM dbo.Person as p
WHERE p.Last_Name = 'Melkin'

SELECT * FROM dbo.Alter_Ego_Person



-------------------------------------------------------------------------
--- so what else can we do here...????
-------------------------------------------------------------------------

-- what happens if we delete an Alter Ego??
-- drop the foreign key
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    DROP CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID;

-- drop the default constraint if it exists
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    DROP CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID;

-- modify the column
ALTER TABLE dbo.Alter_Ego_Person
ADD CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID DEFAULT 1
	FOR Alter_Ego_ID
;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE dbo.Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
    FOREIGN KEY (Alter_Ego_ID)
    REFERENCES dbo.Alter_Ego(Alter_Ego_ID)
	ON DELETE SET DEFAULT 
go



-- now go back and modify the table....


-------------------------------------------------------------------------
-- Who needs to go...
-------------------------------------------------------------------------
SELECT * FROM dbo.Alter_Ego WHERE Alter_Ego_ID > 1
SELECT * FROM dbo.Person WHERE First_Name = 'Ororo' AND Last_Name = 'Munroe'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM dbo.Alter_Ego_Person as aep 
	JOIN dbo.Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN dbo.Alter_Ego as ae 
WHERE (p.First_Name = 'Ororo' AND p.Last_Name = 'Munroe') AND ae.Alter_Ego_Name = 'Storm'


SELECT * FROM dbo.Alter_Ego_Person WHERE Person_ID = 7

DELETE FROM dbo.Alter_Ego WHERE Alter_Ego_Name = 'Storm'

SELECT * FROM dbo.Alter_Ego_Person WHERE Person_ID = 7


-------------------------------------------------------------------------
-- Now - what happens if the default doesn't exist in the reference table?
-------------------------------------------------------------------------
-- drop the foreign key
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    DROP CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID;

-- drop the default constraint
IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    DROP CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID;
GO

-- Note the new default value
IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    ADD CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID
        DEFAULT 0 FOR Alter_Ego_ID;

IF NOT EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID'
          AND parent_object_id = OBJECT_ID('Alter_Ego_Person')
)
    ALTER TABLE dbo.Alter_Ego_Person
    ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
        FOREIGN KEY (Alter_Ego_ID)
        REFERENCES dbo.Alter_Ego (Alter_Ego_ID) ON DELETE SET DEFAULT;
GO


-- re-add storm in...
IF NOT EXISTS (SELECT * FROM dbo.Alter_Ego WHERE Alter_Ego_Name = 'Storm')
INSERT INTO dbo.Alter_Ego (Alter_Ego_Name, Comic_Universe_ID)
OUTPUT inserted.Alter_Ego_ID
SELECT 'Storm', Comic_Universe_ID
FROM dbo.Comic_Universe WHERE Comic_Universe_Name = 'Marvel'

SELECT * FROM dbo.Person

UPDATE dbo.Alter_Ego_Person
SET Alter_Ego_ID = 8
WHERE Person_ID = 7


DELETE FROM dbo.Alter_Ego WHERE Alter_Ego_Name = 'Storm'

SELECT * FROM dbo.Alter_Ego_Person WHERE Person_ID = 7
SELECT * FROM dbo.Alter_Ego WHERE Alter_Ego_Name = 'Storm'

-------------------------------------------------------------------------
-- reset!
-------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE dbo.Alter_Ego_Person DROP CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE dbo.Alter_Ego_Person DROP CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE dbo.Alter_Ego_Person
ADD CONSTRAINT DF_Alter_Ego_Person_Alter_Ego_ID DEFAULT 1
	FOR Alter_Ego_ID
;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'FK_Alter_Ego_Person_Alter_Ego_ID' AND parent_object_id = OBJECT_ID('Alter_Ego_Person'))
ALTER TABLE dbo.Alter_Ego_Person ADD CONSTRAINT FK_Alter_Ego_Person_Alter_Ego_ID
    FOREIGN KEY (Alter_Ego_ID)
    REFERENCES dbo.Alter_Ego(Alter_Ego_ID)
	ON DELETE SET DEFAULT 
go

/***************
 End of Script
***************/