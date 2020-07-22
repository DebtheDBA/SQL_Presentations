USE Superheroes;
GO

-- Add default data for Comic_Universe

IF NOT EXISTS (SELECT * FROM Comic_Universe)
BEGIN
	INSERT INTO Comic_Universe (Comic_Universe_Name)
	VALUES ('No Universe')

	INSERT INTO Comic_Universe (Comic_Universe_Name)
	VALUES ('Marvel'), ('DCU'), ('Cartoon Network')
END;

-- Add default Superhero list
IF NOT EXISTS (SELECT * FROM Alter_Ego)
BEGIN 
	INSERT INTO Alter_Ego (Alter_Ego_Name, Comic_Universe_ID)
	SELECT 'Average Citizen', Comic_Universe_ID
	FROM Comic_Universe WHERE Comic_Universe_Name = 'No Universe'

	INSERT INTO Alter_Ego (Alter_Ego_Name, Comic_Universe_ID)
	SELECT AlterEgos, Comic_Universe_ID
	FROM (VALUES ('Wonder Woman'),('Super Girl'),('Catwoman') ) as egos (AlterEgos)
		CROSS JOIN Comic_Universe as cu
	WHERE cu.Comic_Universe_Name = 'DCU'
	UNION
	SELECT AlterEgos, Comic_Universe_ID
	FROM (VALUES ('Black Widow'),('Spider Girl'),('Storm') ) as egos (AlterEgos)
		CROSS JOIN Comic_Universe as cu
	WHERE cu.Comic_Universe_Name = 'Marvel'

END
