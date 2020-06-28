-- Make sure I'm using the right database
USE tempdb
GO

-- Delete a single known record
SELECT Currency_ID, Currency_Code, Currency_Name
FROM dbo.Currency
WHERE Currency_ID = 8
;

-- Delete Malaysian Ringgit
DELETE FROM dbo.Currency
WHERE Currency_ID = 8
;

-- Confirm delete
SELECT Currency_ID, Currency_Code, Currency_Name
FROM dbo.Currency
;


-- DELETE based on another table

-- We no longer need records for orders that have been completely paid

-- identify accounts where all sales orders have been paid
SELECT a.Account_ID, a.Account_Name, 
	SUM(Total_Amount) as Total_Amount, 
	SUM(Amount_Due) as Amount_Due, 
	COUNT(*) as NoOfOrders
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
GROUP BY a.Account_ID, a.Account_Name
HAVING SUM(Amount_Due) = 0
;

-- start by looking at just the ones for Amazon
SELECT so.Sales_Order_ID, so.Account_ID, so.Contact_Person_ID, 
	so.Total_Amount, so.Amount_Due, so.Last_Updated
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
WHERE a.Account_Name = 'Amazon'
;


-- Delete the records
DELETE so
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
WHERE a.Account_Name = 'Amazon'
;


-- Identify the Sales Orders to delete based on the query to identify the records
SELECT so.Sales_Order_ID, so.Account_ID, so.Contact_Person_ID, 
	so.Total_Amount, so.Amount_Due, so.Last_Updated
FROM dbo.SalesOrder as so
WHERE so.Account_ID IN 
	(
	SELECT a.Account_ID 
	FROM dbo.SalesOrder as s
		JOIN dbo.Account as a ON s.Account_ID = a.Account_ID
	GROUP BY a.Account_ID
	HAVING SUM(Amount_Due) = 0
	)
ORDER BY so.Account_ID
;

-- Deleting those records:
-- Don't run this yet...
-- Show the neat trick first!!!

DELETE so
-- SELECT Sales_Order_ID, Account_ID, Contact_Person_ID, Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder as so
WHERE so.Account_ID IN 
	(
	SELECT a.Account_ID 
	FROM dbo.SalesOrder as s
		JOIN dbo.Account as a ON s.Account_ID = a.Account_ID
	GROUP BY a.Account_ID
	HAVING SUM(Amount_Due) = 0
	)
;


-- run original query to confirm those records are gone
SELECT a.Account_ID, a.Account_Name, 
	SUM(Total_Amount) as Total_Amount, 
	SUM(Amount_Due) as Amount_Due, 
	COUNT(*) as NoOfOrders
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
GROUP BY a.Account_ID, a.Account_Name
HAVING SUM(Amount_Due) = 0
;

GO