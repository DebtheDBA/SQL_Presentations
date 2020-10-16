USE Superheroes;
GO

/******************************
******************************
 Demo: Temporal Tables 
******************************
******************************/

-- Let's rework that history table a little

-- Let's take a look at the alter_ego_person and alter_ego_person_history tables.


-- Alter Alter_Ego_Person to get the system verion columns added. 
-- Note the values for the default column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Alter_Ego_Person') AND name IN ('Sys_Start_Time','Sys_End_Time'))
ALTER TABLE Alter_Ego_Person
ADD 
    Sys_Start_Time		 DATETIME2		GENERATED ALWAYS AS ROW START HIDDEN NOT NULL
		CONSTRAINT DF_Alter_Ego_Person_Sys_Start_Time DEFAULT '19000101 00:00:00.0000000',
    Sys_End_Time		 DATETIME2		GENERATED ALWAYS AS ROW END HIDDEN NOT NULL
		CONSTRAINT DF_Alter_Ego_Person_Sys_End_Time DEFAULT '99991231 23:59:59.9999999',
	PERIOD FOR SYSTEM_TIME (Sys_Start_Time, Sys_End_Time)
;

ALTER TABLE Alter_Ego_Person
DROP CONSTRAINT DF_Alter_Ego_Person_Sys_Start_Time, DF_Alter_Ego_Person_Sys_End_Time
;

SELECT * FROM Alter_Ego_Person
SELECT Alter_Ego_Person_ID, Person_ID, Alter_Ego_ID, Sys_Start_Time, Sys_End_Time FROM Alter_Ego_Person


-- Alter Alter_Ego_Person to system version ON.
ALTER TABLE Alter_Ego_Person 
SET (SYSTEM_VERSIONING = ON (DATA_CONSISTENCY_CHECK = ON));
go

-- Look in the Object Explorer
-- Whoops meant to name it....

ALTER TABLE Alter_Ego_Person
SET (SYSTEM_VERSIONING = OFF);
GO

ALTER TABLE Alter_Ego_Person 
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Alter_Ego_Person_Temporal_History, DATA_CONSISTENCY_CHECK = ON));
go

-- check out Object Explorer


/***************
let's start making some changes 
***************/

-- Alter remaining trigger on Person
CREATE OR ALTER TRIGGER Person_itr ON dbo.Person
FOR INSERT
AS
BEGIN

	INSERT INTO Alter_Ego_Person
	SELECT p.Person_ID, ae.Alter_Ego_ID
	FROM inserted as p
		CROSS JOIN Alter_Ego as ae
	WHERE ae.Alter_Ego_Name = 'Average Citizen'
	
END
GO


-- NOTE THE TIME: 2020-10-13 12:03:58.240
SELECT getutcdate()

-- Add myself back to Person and Alter_Ego_Person

INSERT INTO Person (First_Name, Last_Name)
VALUES ('Deborah', 'Melkin')


select * from Alter_Ego_Person_Temporal_History

-- Set the other women to their correct alter egos. Make some mistakes. 
UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Diana' AND Last_Name = 'Prince') AND Alter_Ego_Name = 'Wonder Woman'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Linda' AND Last_Name = 'Danvers') AND Alter_Ego_Name = 'Super Girl'	

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Selina' AND Last_Name = 'Kyle') AND Alter_Ego_Name = 'Catwoman'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'May' AND Last_Name = 'Parker') AND Alter_Ego_Name = 'Spider Girl'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Natasha' AND Last_Name = 'Romanoff') AND Alter_Ego_Name = 'Black Widow'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Ororo' AND Last_Name = 'Munroe') AND Alter_Ego_Name = 'Storm'

-- How'd I do?
SELECT *
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	JOIN Alter_Ego as ae ON aep.Alter_Ego_ID = ae.Alter_Ego_ID

GO

-- Umm....What do you mean I'm not Wonder Woman? 
UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Deborah' AND Last_Name = 'Melkin') AND Alter_Ego_Name = 'Wonder Woman'


UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Diana' AND Last_Name = 'Prince') AND Alter_Ego_Name = 'Average Citizen'

SELECT getutcdate() --2020-10-13 12:05:00.407

-- Do i have to switch it back? Fine....
UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Deborah' AND Last_Name = 'Melkin') AND Alter_Ego_Name = 'Average Citizen'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN Alter_Ego as ae 
WHERE (First_Name = 'Diana' AND Last_Name = 'Prince') AND Alter_Ego_Name = 'Wonder Woman'

GO 20

--- let's have some fun; Run the above lines 20 times.
-- OK fine.... let's get back to work

-- select from the Alter_Ego_Person for the current time.
SELECT *
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	JOIN Alter_Ego as ae ON aep.Alter_Ego_ID = ae.Alter_Ego_ID
;
GO
--current time: 
-- Remember that time I was wonder woman? ---2020-10-13 12:05:16.947
SELECT * 
FROM (
	SELECT Alter_Ego_ID, Person_ID
	FROM Alter_Ego_Person 
	FOR System_Time AS OF '2020-10-13 12:05:16.947'
) as aep_asof
	JOIN Person as p ON aep_asof.Person_ID = p.Person_ID
	JOIN Alter_Ego as ae ON aep_asof.Alter_Ego_ID = ae.Alter_Ego_ID

-- let's look at some changes
SELECT * 
FROM (
	SELECT Alter_Ego_ID, Person_ID, Sys_Start_Time, Sys_End_Time
	FROM Alter_Ego_Person 
	FOR System_Time BETWEEN '2020-10-13 12:05:16.947' AND '2020-10-13 12:05:46.947'
) as aep_asof
	JOIN Person as p ON aep_asof.Person_ID = p.Person_ID
	JOIN Alter_Ego as ae ON aep_asof.Alter_Ego_ID = ae.Alter_Ego_ID
ORDER BY aep_asof.Sys_Start_Time
GO

SELECT * FROM Alter_Ego_Person_Temporal_History;
GO

CREATE OR ALTER VIEW dbo.Show_Alter_Ego_People
AS 
SELECT ae.Alter_Ego_ID, ae.Alter_Ego_Name, p.Person_ID, p.First_Name, p.Last_Name, aep.Sys_Start_Time, aep.Sys_End_Time 
FROM Alter_Ego_Person as aep 
	JOIN Person as p ON aep.Person_ID = p.Person_ID
	JOIN Alter_Ego as ae ON aep.Alter_Ego_ID = ae.Alter_Ego_ID
GO

SELECT * FROM Show_Alter_Ego_People
FOR SYSTEM_TIME AS OF '2020-10-13 12:05:16.947'

-- Let's check the numbers behind the queries
SELECT count(*) FROM Alter_Ego_Person_Temporal_History

SELECT count(*) FROM Alter_Ego_Person FOR System_Time ALL

-- now look at the data
SELECT * FROM Alter_Ego_Person_Temporal_History ORDER BY Person_ID, Sys_Start_Time

SELECT Alter_Ego_Person_ID, Person_ID, Alter_Ego_ID, Sys_Start_Time, Sys_End_Time FROM Alter_Ego_Person FOR System_Time ALL
ORDER BY Person_ID, Sys_Start_Time

GO

/***************
 End of Script
***************/
