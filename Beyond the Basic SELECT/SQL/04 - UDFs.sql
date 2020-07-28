USE DebsAdventureWorks
GO

/*******************************
User Defined Functions:

1. Confirm you are in the right database 
2. Set STATISTCS IO on
3. Include the Actual Execution Plan (Ctrl + M)
*******************************/

SET STATISTICS IO ON
GO

/******************************************
Scalar Functions

* Look at the definition of ufnGetProductListPrice first.
******************************************/

-- From the AdventureWorks database
CREATE FUNCTION [dbo].[ufnGetProductListPrice](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
BEGIN
    DECLARE @ListPrice money;

    SELECT @ListPrice = plph.[ListPrice] 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductListPriceHistory] plph 
        ON p.[ProductID] = plph.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN plph.[StartDate] AND COALESCE(plph.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @ListPrice;
END;
GO

/******************************************
Now let's look at some queries 
******************************************/
-- notice where the udf is called
SELECT sod.SalesOrderID,
	CarrierTrackingNumber,
	p.ProductID as ProductID, p.Name, p.ProductLine,
	[dbo].[ufnGetProductListPrice](sod.ProductID, sod.ModifiedDate) as ProductListPrice,
	UnitPrice,
	OrderQty
FROM Sales.SalesOrderDetail as sod
	JOIN Production.Product as p ON sod.ProductID = p.ProductID
WHERE p.ProductLine = 'M'
;

-- without the udf
SELECT sod.SalesOrderID,
	sod.CarrierTrackingNumber,
	p.ProductID as ProductID, p.Name, p.ProductLine,
	pl.ListPrice as ProductListPrice,
	sod.UnitPrice,
	sod.OrderQty
FROM Sales.SalesOrderDetail as sod
	JOIN Production.Product as p ON sod.ProductID = p.ProductID
	LEFT JOIN Production.ProductListPriceHistory as pl ON p.ProductID = pl.ProductID
		AND (sod.ModifiedDate BETWEEN pl.[StartDate] AND COALESCE(pl.[EndDate], CONVERT(datetime, '99991231', 112)))
WHERE p.ProductLine = 'M'
;

GO


/******************************************
Inline Table Functions

* Look at the definition for [ufnHasCustomerAccess] first
******************************************/

-- Deb's version of the [Security].[customerAccessPredicate] functions

CREATE OR ALTER FUNCTION [Demo].[ufnHasCustomerAccess](@LoginID nvarchar(256))
	RETURNS TABLE
	WITH SCHEMABINDING
AS
	RETURN SELECT TerritoryID AS accessResult
	FROM HumanResources.Employee as e 
	INNER JOIN Sales.SalesPerson as sp ON sp.BusinessEntityID = e.BusinessEntityID
	WHERE
		( RIGHT(e.LoginID, LEN(e.LoginID) - LEN('adventure-works\')) = @LoginID ) 

GO

/******************************************
Now let's look at some queries
******************************************/

DECLARE @LoginID nvarchar(256)
SELECT @LoginID = 'jillian0'
-- Other IDs to test: amy0, jae0

SELECT Access.accessResult, soh.TerritoryID, soh.SalesOrderID, soh.SalesOrderNumber, soh.SalesPersonID 
FROM Sales.SalesOrderHeader as soh
	LEFT JOIN Demo.[ufnHasCustomerAccess](@LoginID) as Access ON soh.TerritoryID = Access.accessResult
;




/******************************************
Multi-Statement Table Value Functions

* Look at the definition for ufnGetContactInformation first
******************************************/
-- From the AdventureWorks database

CREATE FUNCTION [dbo].[ufnGetContactInformation](@PersonID int)
RETURNS @retContactInformation TABLE 
(
    -- Columns returned by the function
    [PersonID] int NOT NULL, 
    [FirstName] [nvarchar](50) NULL, 
    [LastName] [nvarchar](50) NULL, 
	[JobTitle] [nvarchar](50) NULL,
    [BusinessEntityType] [nvarchar](50) NULL
)
AS 
-- Returns the first name, last name, job title and business entity type for the specified contact.
-- Since a contact can serve multiple roles, more than one row may be returned.
BEGIN
	IF @PersonID IS NOT NULL 
		BEGIN
		IF EXISTS(SELECT * FROM [HumanResources].[Employee] e 
					WHERE e.[BusinessEntityID] = @PersonID) 
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, e.[JobTitle], 'Employee'
				FROM [HumanResources].[Employee] AS e
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = e.[BusinessEntityID]
				WHERE e.[BusinessEntityID] = @PersonID;

		IF EXISTS(SELECT * FROM [Purchasing].[Vendor] AS v
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = v.[BusinessEntityID]
					WHERE bec.[PersonID] = @PersonID)
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, ct.[Name], 'Vendor Contact' 
				FROM [Purchasing].[Vendor] AS v
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = v.[BusinessEntityID]
					INNER JOIN [Person].ContactType ct
					ON ct.[ContactTypeID] = bec.[ContactTypeID]
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = bec.[PersonID]
				WHERE bec.[PersonID] = @PersonID;
		
		IF EXISTS(SELECT * FROM [Sales].[Store] AS s
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = s.[BusinessEntityID]
					WHERE bec.[PersonID] = @PersonID)
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, ct.[Name], 'Store Contact' 
				FROM [Sales].[Store] AS s
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = s.[BusinessEntityID]
					INNER JOIN [Person].ContactType ct
					ON ct.[ContactTypeID] = bec.[ContactTypeID]
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = bec.[PersonID]
				WHERE bec.[PersonID] = @PersonID;

		IF EXISTS(SELECT * FROM [Person].[Person] AS p
					INNER JOIN [Sales].[Customer] AS c
					ON c.[PersonID] = p.[BusinessEntityID]
					WHERE p.[BusinessEntityID] = @PersonID AND c.[StoreID] IS NULL) 
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, NULL, 'Consumer' 
				FROM [Person].[Person] AS p
					INNER JOIN [Sales].[Customer] AS c
					ON c.[PersonID] = p.[BusinessEntityID]
					WHERE p.[BusinessEntityID] = @PersonID AND c.[StoreID] IS NULL; 
		END

	RETURN;
END;
GO


/******************************************
Now let's look at some queries
******************************************/
-- Selecting from a UDF by itself
SELECT PersonID, FirstName, LastName, JobTitle, BusinessEntityType
FROM dbo.ufnGetContactInformation (5)
;

-- Selecting from a UDF JOINING to another table.
SELECT p.FirstName, p.LastName, udf.JobTitle, udf.BusinessEntityType 
FROM Person.Person as p
	CROSS APPLY [dbo].[ufnGetContactInformation] (p.BusinessEntityID) as udf
WHERE p.PersonType = 'VC' -- vendor
;

-- compare to not using the udf
SELECT 
	p.FirstName, p.LastName, ct.Name, 
	CASE WHEN p.PersonType = 'VC' 
		THEN 'Vendor Contact' 
		ELSE 'Something Else' 
	END as BusinessEntityType
FROM [Purchasing].[Vendor] AS v
	INNER JOIN [Person].[BusinessEntityContact] as bec ON bec.[BusinessEntityID] = v.[BusinessEntityID]
	INNER JOIN [Person].ContactType as ct ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] as p ON p.[BusinessEntityID] = bec.[PersonID]
WHERE p.PersonType = 'VC' -- vendor
;				


-- Now let's check out the SQL 2017 changes

GO

-- end of script
