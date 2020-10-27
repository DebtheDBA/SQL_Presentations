USE Superheroes
GO

CREATE OR ALTER PROCEDURE dbo.Add_Good_Deed (
	@Person_Name VARCHAR(250),
	@Good_Deed_Type_Name VARCHAR(250),
	@Good_Deed_Description VARCHAR(250),
	@Good_Timestamp DATETIME
)
AS
BEGIN

	DECLARE 
		@Person_ID INT,
		@Good_Deed_Type_ID INT;

	-----
	-- Get Person_ID
	SELECT @Person_ID = Person_ID
	FROM dbo.Person
	WHERE (Person.First_Name + ' ' + Person.Last_Name) = @Person_Name;

	-----
	-- Get Good_Deed_Type_ID
	SELECT @Good_Deed_Type_ID = Good_Deed_Type_ID
	FROM dbo.Good_Deed_Type
	WHERE Good_Deed_Type_Name = @Good_Deed_Type_Name;

	
	INSERT INTO Good_Deed_History (
		Good_Deed_Type_ID, 
		Good_Deed_Person_ID, 
		Good_Deed_Description, 
		Good_Deed_Timestamp
	)
	VALUES (
		@Good_Deed_Type_ID,
		@Person_ID,
		@Good_Deed_Description,
		COALESCE(@Good_Timestamp, GETDATE())
	);

END
GO