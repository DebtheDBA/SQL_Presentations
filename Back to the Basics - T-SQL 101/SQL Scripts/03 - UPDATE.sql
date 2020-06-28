-- Make sure I'm using the right database
USE tempdb
GO

-- UPDATE based on known information
-- update single record on single piece of information

-- Confirm the initial data
SELECT a.Account_ID, a.Account_Name, a.Primary_Contact_Person_ID, a.Alternate_Contact_Person_ID 
FROM dbo.Account as a
WHERE a.Account_Name = 'Marvel'
;












-- Update record
UPDATE dbo.Account
SET Account_Name = 'S.H.I.E.L.D.'
WHERE Account_Name = 'Marvel'
;

-- Confirm the update
SELECT a.Account_ID, a.Account_Name, a.Primary_Contact_Person_ID, a.Alternate_Contact_Person_ID 
FROM dbo.Account as a
WHERE a.Account_Name = 'S.H.I.E.L.D.'
;


-- UPDATE multiple columns
-- Confirm the information
SELECT p.Person_ID, p.Full_Name, p.Last_Name, p.First_Name
FROM dbo.Person as p
WHERE p.Full_Name = 'Selina Kyle'
;

-- Update
UPDATE p
SET Last_Name = p.First_Name,
	First_Name = p.Last_Name
FROM dbo.Person as p
WHERE p.Full_Name = 'Selina Kyle'
;


-- Confirm the update
SELECT p.Person_ID, p.Full_Name, p.Last_Name, p.First_Name
FROM dbo.Person as p
WHERE p.Full_Name = 'Selina Kyle'
;


-- UPDATE multiple rows at the same time

-- We want to update the records where the amount due is the same as the total amount
SELECT Sales_Order_ID, Account_ID, Contact_Person_ID, 
	Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder
WHERE Total_Amount = Amount_Due
;

-- update with a known value
UPDATE so
SET Amount_Due = 0,
	Last_Updated = getdate()
FROM dbo.SalesOrder as so
WHERE Total_Amount = Amount_Due
;

-- confirm the update
SELECT Sales_Order_ID, Account_ID, Contact_Person_ID, 
	Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder
WHERE Amount_Due = 0
;

-- for sales orders where less than $200 is due, 
-- update the amount due to either 0 or $100 less

-- I want to see the records affected and what the new amount due would be
SELECT Sales_Order_ID, a.Account_Name, p.Full_Name, 
	Total_Amount, Amount_Due, Last_Updated,
	CASE WHEN so.Total_Amount < 400 THEN 0 
					ELSE Amount_Due - 100
				END as New_Amount_Due
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
	JOIN dbo.Person as p ON a.Primary_Contact_Person_ID = p.Person_ID
WHERE so.Amount_Due <= 200
AND so.Amount_Due > 0
;


-- Update records
-- Note what's in the comment
UPDATE so
SET Last_Updated = getdate(),
	Amount_Due = CASE WHEN so.Total_Amount < 400 THEN 0 
					ELSE Amount_Due - 100
				END
-- SELECT so.Sales_Order_ID, a.Account_ID, p.Full_Name, CASE WHEN so.Total_Amount < 400 THEN 0 ELSE Amount_Due - 100 END
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
	JOIN dbo.Person as p ON a.Primary_Contact_Person_ID = p.Person_ID
WHERE so.Amount_Due <= 200
AND so.Amount_Due > 0
;

-- Confirm the update
SELECT Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder
WHERE Last_Updated > convert(varchar(10), getdate(), 101)
ORDER BY Last_Updated DESC
;

GO