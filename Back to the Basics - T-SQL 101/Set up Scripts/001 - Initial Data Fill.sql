-- Make sure I'm using the right database
USE tempdb
GO

/*** Initial dbo.Person Insert ***/

INSERT INTO dbo.Person (Full_Name, Last_Name, First_Name)
VALUES 
	('Diana Prince', 'Prince', 'Diana'), -- Wonder Woman, DC
	('Linda Danvers', 'Danvers', 'Linda'), -- Super Girl, DC
	('May Parker', 'Parker', 'May'), -- Spider Girl, Marvel
	('Selina Kyle', 'Selina', 'Kyle'), -- Catwoman ** We'll need to fix this via update, DC
	('Natasha Romanoff', 'Romanoff', 'Natasha'), -- Black Widow, Marvel
	('Ororo Munroe', 'Munroe', 'Ororo') -- Storm, Marvel
;

/*** Initial Accounts ***/


-- Everyone should have their own dbo.Account
INSERT INTO dbo.Account (Account_Name, Primary_Contact_Person_ID)
SELECT Last_Name + CASE WHEN Person_ID > 3 THEN ' Inc.' ELSE ' Corporation' END, Person_ID
FROM dbo.Person
ORDER BY Last_Name
;

--May Parker and Natasha Romanoff work at Marvel
INSERT INTO dbo.Account (Account_Name, Primary_Contact_Person_ID, Alternate_Contact_Person_ID)
VALUES ('Marvel', 3, 5)
;

-- Create Sales Orders
INSERT INTO dbo.SalesOrder (Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated)
SELECT Account_ID, Primary_Contact_Person_ID, Account_ID * 100 as Total_Amount, 
	CASE WHEN (Account_ID * 100)/Primary_Contact_Person_ID > (Account_ID * 100)
		THEN Account_ID * 100
		ELSE (Account_ID * 100)/Primary_Contact_Person_ID
	END as Amount_Due, 
	-- using dateadd to modify the number of days to create varying days for the orders.
	dateadd(hh, -(Account_ID + 10), dateadd(dd, -Account_ID, getdate()))
FROM dbo.Account
;

INSERT INTO dbo.SalesOrder (Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated)
SELECT Account_ID, Primary_Contact_Person_ID, 
	Primary_Contact_Person_ID * 100 as Total_Amount,
	CASE WHEN (Account_ID * 75) > (Primary_Contact_Person_ID * 100 )
		THEN Primary_Contact_Person_ID * 100 
		ELSE Account_ID * 75
	END as Amount_Due ,  
	dateadd(hh, -(Account_ID + 5), dateadd(dd, -(Account_ID + 8), getdate()))
FROM dbo.Account
;

INSERT INTO dbo.SalesOrder (Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated)
SELECT Account_ID, Contact_Person_ID, SUM(Total_Amount) as Total_Amount, FLOOR(SUM(Total_Amount)/Contact_Person_ID) as Amount_Due,    
	dateadd(hh, -(Account_ID + 8), dateadd(dd, -(Account_ID + 4), getdate()))
FROM dbo.SalesOrder
GROUP BY Account_ID, Contact_Person_ID
;

-- Add some international currencies
INSERT INTO dbo.Currency (Currency_Code, Currency_Name, To_USD, From_USD)
VALUES 
	('USD', 'US Dollar', 1.00, 1.00),
	('EUR', 'Euro', 0.918549, 1.088673),
	('GBP', 'British Pound', 0.777003, 1.286996),
	('INR', 'Indian Rupee', 64.250086, 0.015564),
	('AUD', 'Australian Dollar', 1.348412, 0.741613),
	('CAD', 'Canadian Dollar', 1.372374, 0.728664) 
;


