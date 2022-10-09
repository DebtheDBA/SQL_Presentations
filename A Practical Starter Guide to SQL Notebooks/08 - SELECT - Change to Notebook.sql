-- Make sure I'm using the right database
USE tempdb
GO

/*********************
SELECT
*********************/

-- Initial SELECT

-- SELECT * is a shortcut for all the column
-- Do NOT use in Production!!!!!!!
SELECT *
FROM dbo.Person
WHERE Last_Name = 'Prince'
;








GO

-- Let's try this instead
SELECT Person_ID, Full_Name, First_Name, Last_Name
FROM dbo.Person
WHERE Last_Name = 'Prince'
;

-- Let's just select everything from the table. 
SELECT Person_ID, Full_Name, First_Name, Last_Name
FROM dbo.Person
WHERE Person_ID > 0
;

SELECT Account_ID, Account_Name, 
	Primary_Contact_Person_ID, Alternate_Contact_Person_ID 
FROM dbo.Account
WHERE Account_ID < 10
;
GO

/*********************
JOINs
*********************/

-- INNER JOIN
-- Find out the name for the Primary Contact Person
SELECT a.Account_ID, 
	a.Account_Name, 
	a.Primary_Contact_Person_ID, 
	a.Alternate_Contact_Person_ID,
	p.Full_Name as Primary_Contact_Person
FROM dbo.Account as a	
	JOIN dbo.Person as p ON a.Primary_Contact_Person_ID = p.Person_ID
;

-- Find out the name for the Alternate Contact Person
SELECT a.Account_ID, a.Account_Name, 
	a.Primary_Contact_Person_ID, a.Alternate_Contact_Person_ID,
	p.Full_Name as Alternate_Contact_Person
FROM dbo.Account as a	
	JOIN dbo.Person as p ON a.Alternate_Contact_Person_ID = p.Person_ID
;


-- LEFT JOIN
-- Show the Account info and the Alternate Contact Person, if there is one.
SELECT a.Account_ID, a.Account_Name, 
	a.Primary_Contact_Person_ID, 
	a.Alternate_Contact_Person_ID,
	p.Full_Name as Alternate_Contact_Person
FROM dbo.Account as a	
	LEFT JOIN dbo.Person as p ON a.Alternate_Contact_Person_ID = p.Person_ID
;


-- RIGHT JOIN 
-- Show the Person and the Account info if they are an alternate contact.
SELECT a.Account_ID, a.Account_Name, 
	a.Primary_Contact_Person_ID, 
	a.Alternate_Contact_Person_ID,
	p.Full_Name as Person_Name
FROM dbo.Account as a	
	RIGHT JOIN dbo.Person as p ON a.Alternate_Contact_Person_ID = p.Person_ID
;


-- FULL OUTER JOIN 
-- Show me all the Person and Account information
SELECT a.Account_ID, a.Account_Name, 
	a.Primary_Contact_Person_ID, 
	a.Alternate_Contact_Person_ID,
	p.Full_Name as Person_Name
FROM dbo.Account as a	
	FULL OUTER JOIN dbo.Person as p ON a.Alternate_Contact_Person_ID = p.Person_ID
;

-- Why we would use FULL OUTER JOIN?
SELECT 
	CASE WHEN p.Person_ID IS NOT NULL THEN p.Full_Name 
		ELSE a.Account_Name 
	END as Person_Or_Account,
	CASE WHEN p.Person_ID IS NULL THEN 1 
		ELSE 0 
	END as Is_Account,
	CASE WHEN p.Person_ID IS NOT NULL THEN 1 
		ELSE 0 
	END as Is_Person,
	CASE WHEN a.Alternate_Contact_Person_ID IS NOT NULL THEN 1 
		ELSE 0 
	END as Is_Alternate_Contact
FROM dbo.Account as a	
	FULL OUTER JOIN dbo.Person as p ON a.Alternate_Contact_Person_ID = p.Person_ID
;


-- CROSS JOIN
-- I want to see the combination of all the different currencies

-- Show the currencies that we have
SELECT Currency_ID, Currency_Code, Currency_Name, To_USD
FROM dbo.Currency
;

-- Notice the JOIN criteria
SELECT LeftC.Currency_ID, LeftC.Currency_Code, LeftC.Currency_Name, 
	RightC.Currency_ID, RightC.Currency_Code, RightC.Currency_Name
FROM dbo.Currency as LeftC
	CROSS JOIN dbo.Currency as RightC
;


-- Why would I want to use a CROSS JOIN?
-- I want to see how to convert the currencies to each other
SELECT LeftC.Currency_Code + '/' + RightC.Currency_Code as Currency_Conversion, 
	LeftC.Currency_Name + ' to ' + RightC.Currency_Name as Currency_Conversion_Desc,
	LeftC.To_USD/RightC.To_USD as To_Curr_Rate, 
	LeftC.From_USD/RightC.From_USD as From_Curr_Rate
FROM dbo.Currency as LeftC
	CROSS JOIN dbo.Currency as RightC
WHERE RightC.Currency_Code <> LeftC.Currency_Code 
;


-- Just show the conversions for Euro
-- Notice the effect of the WHERE clause
SELECT LeftC.Currency_Code + '/' + RightC.Currency_Code as Currency_Conversion, 
	LeftC.Currency_Name + ' to ' + RightC.Currency_Name as Currency_Conversion_Desc,
	LeftC.To_USD/RightC.To_USD as To_Curr_Rate, 
	LeftC.From_USD/RightC.From_USD as From_Curr_Rate
FROM dbo.Currency as LeftC
	CROSS JOIN dbo.Currency as RightC
WHERE RightC.Currency_Code <> LeftC.Currency_Code 
AND LeftC.Currency_Code = 'EUR'
;


-- Just show the conversions to Euro
SELECT LeftC.Currency_Code + '/' + RightC.Currency_Code as Currency_Conversion, 
	LeftC.Currency_Name + ' to ' + RightC.Currency_Name as Currency_Conversion_Desc,
	LeftC.To_USD/RightC.To_USD as To_Curr_Rate, 
	LeftC.From_USD/RightC.From_USD as From_Curr_Rate
FROM dbo.Currency as LeftC
	CROSS JOIN dbo.Currency as RightC
WHERE RightC.Currency_Code <> LeftC.Currency_Code 
AND RightC.Currency_Code = 'EUR'
;


/*********************
GROUP BY, ORDER BY
*********************/

-- Let's see what's in the table
SELECT Sales_Order_ID, Account_ID, Contact_Person_ID, 
	Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder
;


-- GROUP BY
-- I want to see total amounts and amount due for all the sales orders 
-- for each account

SELECT a.Account_Name, 
	SUM(so.Total_Amount) as Total_Amount, 
	SUM(so.Amount_Due) as Amount_Due
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
GROUP BY a.Account_Name
;


-- HAVING 
-- I want to see total amounts and amount due for all the sales orders 
-- for each account when they owe more than 500

SELECT a.Account_Name, 
	SUM(Total_Amount) as Total, 
	SUM(Amount_Due) as Total_Due
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
GROUP BY a.Account_Name
HAVING SUM(Amount_Due) > 500
;


-- ORDER BY 
-- I want to see the previous results ordered by the contact's last name.

SELECT a.Account_Name, p.First_Name, p.Last_Name,
	SUM(so.Total_Amount) as Total, 
	SUM(so.Amount_Due) as Total_Due
FROM dbo.SalesOrder as so
	JOIN dbo.Account as a ON so.Account_ID = a.Account_ID
	JOIN dbo.Person as p ON a.Primary_Contact_Person_ID = p.Person_ID
GROUP BY a.Account_Name, p.First_Name, p.Last_Name
HAVING SUM(so.Amount_Due) > 500
ORDER BY p.Last_Name 
;


-- ORDER BY without the group by
-- Sort the orders based on Amount Due from most due to the least due 
-- and by the most recent date.
SELECT Sales_Order_ID, Account_ID, Contact_Person_ID, 
	Total_Amount, Amount_Due, Last_Updated
FROM dbo.SalesOrder
WHERE Amount_Due < 200
ORDER BY 
	Amount_Due DESC, 
	Last_Updated DESC
;

GO
