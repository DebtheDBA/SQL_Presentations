-- Make sure I'm using the right database
USE tempdb
GO
	
-- Insert based on known information

-- Confirm the dbo.Person's ID
SELECT Person_ID, Full_Name, Last_Name, First_Name
FROM dbo.Person
WHERE Full_Name = 'Selina Kyle'
;


-- Selina Kyle works at Hedare Beauty
INSERT INTO dbo.Account (Account_Name, Primary_Contact_Person_ID) 
VALUES ('Hedare Beauty', 4)
;


-- Confirm insert
SELECT Account_ID, Account_Name, Primary_Contact_Person_ID, Alternate_Contact_Person_ID 
FROM dbo.Account
WHERE Account_Name = 'Hedare Beauty'
;


-- Insert multiple known values at once 

-- Confirm what's in the table
SELECT Currency_ID, Currency_Code, Currency_Name, To_USD, From_USD
FROM dbo.Currency
;


-- Insert the multiple values
INSERT INTO dbo.Currency (Currency_Code, Currency_Name, To_USD, From_USD)
VALUES 
	('CHF', 'Swiss Franc', 0.994767, 1.005260),
	('MYR', 'Malaysian Ringgit', 4.329460, 0.230976),
	('JPY', 'Japanese Yen', 112.880577, 0.008859),
	('CNY', 'Chinese Yuan Renminbi', 6.897558, 0.144979)
;


-- Confirm the inserts
SELECT Currency_ID, Currency_Code, Currency_Name, To_USD, From_USD
FROM dbo.Currency
;


-- Insert based on a SELECT statement

-- Select the data we want to insert
SELECT Full_Name, Person_ID
FROM dbo.Person
WHERE Last_Name = 'Prince'
;


-- Diana Prince works at Amazon
INSERT INTO dbo.Account (Account_Name, Primary_Contact_Person_ID)
SELECT 'Amazon' as Account_Name,
	Person_ID
FROM dbo.Person
WHERE Last_Name = 'Prince'
;


-- confirm the inserts for the new accounts created
SELECT Account_ID, Account_Name, Primary_Contact_Person_ID, Alternate_Contact_Person_ID
FROM dbo.Account
WHERE Account_ID > 7
;


-- Insert multiple records

-- Let's create some sales orders for accounts
-- determine the records we want to insert
-- Note the WHERE clause...
SELECT 
	a.Account_ID, 
	a.Primary_Contact_Person_ID, 
	-- setting the total amount to be the account id multiplied by 100
	a.Account_ID * 100 as Total_Amount, 
	-- creating amount due values using the account and person IDs
	CASE WHEN (a.Account_ID * 100)/Primary_Contact_Person_ID > (a.Account_ID * 100)
		THEN a.Account_ID * 100
		ELSE (a.Account_ID * 100)/Primary_Contact_Person_ID
	END as Amount_Due, 
	-- setting the last updated value to be the current date and time
	getdate() as Last_Updated
FROM dbo.Account as a
	LEFT JOIN dbo.SalesOrder as so ON a.Account_ID = so.Account_ID
WHERE so.Sales_Order_ID IS NULL
;


-- insert the records
INSERT INTO dbo.SalesOrder
	(Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated)
SELECT 
	a.Account_ID, 
	a.Primary_Contact_Person_ID as Contact_Person_ID, 
	a.Account_ID * 100 as Total_Amount, 
	CASE WHEN (a.Account_ID * 100)/Primary_Contact_Person_ID > (a.Account_ID * 100)
		THEN a.Account_ID * 100
		ELSE (a.Account_ID * 100)/Primary_Contact_Person_ID
	END as Amount_Due, 
	getdate() as Last_Updated
FROM dbo.Account as a
	LEFT JOIN dbo.SalesOrder as so ON a.Account_ID = so.Account_ID
WHERE so.Sales_Order_ID IS NULL
;


-- confirm new orders
SELECT Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder
WHERE Last_Updated > convert(varchar(10), getdate(), 101)
;

GO
	