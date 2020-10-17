USE Superheroes
GO


INSERT INTO dbo.Good_Deed_Type (Good_Deed_Type_Name)
SELECT 'HeLp PeRsOn'
UNION ALL
SELECT 'hElP pErSon'
UNION ALL
SELECT 'Steal from poor, give to self'
UNION ALL
SELECT 'Embarrass hero'
UNION ALL
SELECT 'Dominate world';
GO


INSERT INTO dbo.Person (First_Name, Last_Name)
SELECT 'Doctor', 'Who'
UNION ALL
SELECT 'xXx', 'aAa'
UNION ALL
SELECT 'yYy', 'bBb'
UNION ALL
SELECT 'zZz', 'cCc'
UNION ALL
SELECT 'Doctor', 'Doom'
UNION ALL
SELECT 'Lex', 'Luthor'
UNION ALL
SELECT 'The', 'Master'
GO


-----
-- 2020-07-01 = System hack
EXEC dbo.Add_Good_Deed
	@Person_Name = 'xXx aAa',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'HeLp PeRsOn',		-- VARCHAR(250)
	@Good_Deed_Description = 'All your base are belong to us',		-- VARCHAR(250)
	@Good_Timestamp = '2020-07-01'				-- DATETIME

EXEC dbo.Add_Good_Deed
	@Person_Name = 'yYy bBb',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'HeLp PeRsOn',		-- VARCHAR(250)
	@Good_Deed_Description = 'All your base are belong to us',		-- VARCHAR(250)
	@Good_Timestamp = '2020-07-01'				-- DATETIME

EXEC dbo.Add_Good_Deed
	@Person_Name = 'zZz cCc',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'HeLp PeRsOn',		-- VARCHAR(250)
	@Good_Deed_Description = 'All your base are belong to us',		-- VARCHAR(250)
	@Good_Timestamp = '2020-07-01'				-- DATETIME

EXEC dbo.Add_Good_Deed
	@Person_Name = 'xXx aAa',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'hElP pErSon',		-- VARCHAR(250)
	@Good_Deed_Description = 'All your base are belong to us',		-- VARCHAR(250)
	@Good_Timestamp = '2020-07-01'				-- DATETIME

EXEC dbo.Add_Good_Deed
	@Person_Name = 'yYy bBb',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'hElP pErSon',		-- VARCHAR(250)
	@Good_Deed_Description = 'All your base are belong to us',		-- VARCHAR(250)
	@Good_Timestamp = '2020-07-01'				-- DATETIME


-----
-- 2020-06-15 = Bad data
EXEC dbo.Add_Good_Deed
	@Person_Name = 'xXx aAa',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'HeLp PeRsOn',		-- VARCHAR(250)
	@Good_Deed_Description = 'Hail Hydra',		-- VARCHAR(250)
	@Good_Timestamp = '2020-06-15'				-- DATETIME


EXEC dbo.Add_Good_Deed
	@Person_Name = 'yYy bBb',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'HeLp PeRsOn',		-- VARCHAR(250)
	@Good_Deed_Description = 'Hail Hydra',		-- VARCHAR(250)
	@Good_Timestamp = '2020-06-15'				-- DATETIME

EXEC dbo.Add_Good_Deed
	@Person_Name = 'zZz cCc',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'HeLp PeRsOn',		-- VARCHAR(250)
	@Good_Deed_Description = 'Hail Hydra',		-- VARCHAR(250)
	@Good_Timestamp = '2020-06-15'				-- DATETIME


-----
-- 1950-01-15 = More bad data
EXEC dbo.Add_Good_Deed
	@Person_Name = 'Peggy Carter',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Stop crime',		-- VARCHAR(250)
	@Good_Deed_Description = 'Stopped money laundering by Hydra',		-- VARCHAR(250)
	@Good_Timestamp = '1950-01-01'				-- DATETIME


EXEC dbo.Add_Good_Deed
	@Person_Name = 'Peggy Carter',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Save city',		-- VARCHAR(250)
	@Good_Deed_Description = 'Foiled Hydra',		-- VARCHAR(250)
	@Good_Timestamp = '1950-01-01'				-- DATETIME

EXEC dbo.Add_Good_Deed
	@Person_Name = 'Peggy Carter',				-- VARCHAR(250)
	@Good_Deed_Type_Name = 'Defeat supervillan',		-- VARCHAR(250)
	@Good_Deed_Description = 'Stopped band of Red Skull impersonators',		-- VARCHAR(250)
	@Good_Timestamp = '1950-01-01'				-- DATETIME



-- Add existing ETL error records
INSERT INTO dbo.ETL_Error_Log (
	Error_Description,
	CSV_Data,
	Error_Timestamp
)
SELECT 'Good Deed not found', 'Peggy Carter,Foiled Hydra,Save city,NULL', '2020-05-19'
UNION ALL
SELECT 'Person not found', 'Tony Stark,Defeated the Mandarin,Defeat supervillan,', '2020-05-19'
UNION ALL
SELECT 'Person not found', 'Melkin Deborah,Help person,Prevented intern from dropping Prod,NULL', '2020-05-19'

UNION ALL
SELECT 'Translation error', 'Zero Wing,All your base are belong to us,All your base are belong to us,NULL', '2020-05-19'
UNION ALL
SELECT 'Translation error', 'Zero Wing,Somebody set up us the bomb,Somebody set up us the bomb,NULL', '2020-05-19'
UNION ALL
SELECT 'Mismatched number of Values', 'Zero Wing,You have no chance to survive make your time,NULL', '2020-05-19'


-- Delete a Good Deed
DELETE 
FROM dbo.Good_Deed_Type
WHERE Good_Deed_Type_Name = 'Foiled Hydra';
