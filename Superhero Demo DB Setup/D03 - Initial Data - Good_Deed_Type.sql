IF NOT EXISTS (SELECT * FROM Person WHERE First_Name = 'Peggy' AND Last_Name = 'Carter')
INSERT INTO dbo.Person (First_Name, Last_Name) 
SELECT 'Peggy', 'Carter';


IF NOT EXISTS (SELECT * FROM dbo.Good_Deed_Type)
INSERT INTO dbo.Good_Deed_Type (Good_Deed_Type_Name)
VALUES 
	('Foiled Hydra'),
	('Rescue animal'),
	('Stop crime'),
	('Help person'),
	('Save city'),
	('Defeat supervillan');
GO


EXEC dbo.Add_Good_Deed
	@Person_Name = 'Deborah Melkin',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Help person',		-- VARCHAR(250)
	@Good_Deed_Description = 'Helped Andy cross the road safely',		-- VARCHAR(250)
	@Good_Timestamp = '2020-05-20';				-- DATETIME

	
EXEC dbo.Add_Good_Deed
	@Person_Name = 'Selina Kyle',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Rescue animal',		-- VARCHAR(250)
	@Good_Deed_Description = 'Saved a cat from a bat',		-- VARCHAR(250)
	@Good_Timestamp = '2020-05-20';				-- DATETIME


EXEC dbo.Add_Good_Deed
	@Person_Name = 'May Parker',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Help person',		-- VARCHAR(250)
	@Good_Deed_Description = 'Consoled Peter over loss of Uncle Ben',		-- VARCHAR(250)
	@Good_Timestamp = '2010-05-20';				-- DATETIME


EXEC dbo.Add_Good_Deed
	@Person_Name = 'Deborah Melkin',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Defeat supervillan',		-- VARCHAR(250)
	@Good_Deed_Description = 'IDERA Ace defeats Dr Deadlock',		-- VARCHAR(250)
	@Good_Timestamp = '2020-05-19';				-- DATETIME


EXEC dbo.Add_Good_Deed
	@Person_Name = 'Selina Kyle',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Rescue animal',		-- VARCHAR(250)
	@Good_Deed_Description = 'Saved a bat',		-- VARCHAR(250)
	@Good_Timestamp = '2020-05-20';				-- DATETIME
GO