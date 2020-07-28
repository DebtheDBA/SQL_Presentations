USE [DebsAdventureWorks]
GO

/*******************************************************************************************
Views

Instructions:
* Turn on Actual Execution Plans (Ctrl+M) before running the queries on this page.
*******************************************************************************************/

/*******************************************************************************************
Let's look at this view from the AdventureWorks database
(some extra formatting changes from Deb)
*******************************************************************************************/

CREATE VIEW [Sales].[vSalesPerson] 
AS 
SELECT 
    s.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,[StateProvinceName] = sp.[Name]
    ,a.[PostalCode]
    ,[CountryRegionName] = cr.[Name]
    ,[TerritoryName] = st.[Name]
    ,[TerritoryGroup] = st.[Group]
    ,s.[SalesQuota]
    ,s.[SalesYTD]
    ,s.[SalesLastYear]
FROM [Sales].[SalesPerson] s
    INNER JOIN [HumanResources].[Employee] e ON e.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[Person] p ON p.[BusinessEntityID] = s.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea ON bea.[BusinessEntityID] = s.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Sales].[SalesTerritory] st ON st.[TerritoryID] = s.[TerritoryID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO


/*******************************************************************************************
Now let's look at some queries using the view
*******************************************************************************************/

-- Selecting from the view by itself
SELECT sp.BusinessEntityID,
	sp.Title,
	sp.FirstName,
	sp.MiddleName,
	sp.LastName,
	sp.Suffix,
	sp.JobTitle,
	sp.PhoneNumber,
	sp.PhoneNumberType,
	sp.EmailAddress,
	sp.EmailPromotion,
	sp.AddressLine1,
	sp.AddressLine2,
	sp.City,
	sp.StateProvinceName,
	sp.PostalCode,
	sp.CountryRegionName,
	sp.TerritoryName,
	sp.TerritoryGroup,
	sp.SalesQuota,
	sp.SalesYTD,
	sp.SalesLastYear
FROM Sales.vSalesPerson as sp
;




/*******************************************************************************************/
--what happens when you start joining a view to tables.
SELECT p.PersonType, 
	sp.BusinessEntityID, 
	sp.JobTitle, 
	sp.FirstName, 
	sp.LastName, 
	sp.TerritoryName
FROM   Person.Person as p 
	JOIN Sales.vSalesPerson as sp ON p.BusinessEntityID = sp.BusinessEntityID
;











/*******************************************************************************************/
-- compare the above query with just the tables you need
SELECT p.PersonType, p.BusinessEntityID, e.JobTitle, p.FirstName, p.LastName, st.Name as TerritoryName 
FROM Person.Person as p
    INNER JOIN [HumanResources].[Employee] as e ON e.[BusinessEntityID] = p.[BusinessEntityID]
	INNER JOIN [Sales].[SalesPerson] as s ON p.BusinessEntityID = s.BusinessEntityID
	LEFT OUTER JOIN [Sales].[SalesTerritory] as st ON st.[TerritoryID] = s.[TerritoryID]
;
GO

	
/*******************************************************************************************/
/*******************************************************************************************
-- SCHEMABINDING, INDEXED VIEWS

-- First, let's look at the view definition: vProductAndDescription
*******************************************************************************************/

CREATE VIEW [Production].[vProductAndDescription] 
WITH SCHEMABINDING 
AS 
-- View (indexed or standard) to display products and product descriptions by language.
SELECT 
    p.[ProductID] 
    ,p.[Name] 
    ,pm.[Name] AS [ProductModel] 
    ,pmx.[CultureID] 
    ,pd.[Description] 
FROM [Production].[Product] p 
    INNER JOIN [Production].[ProductModel] pm ON p.[ProductModelID] = pm.[ProductModelID] 
    INNER JOIN [Production].[ProductModelProductDescriptionCulture] pmx ON pm.[ProductModelID] = pmx.[ProductModelID] 
    INNER JOIN [Production].[ProductDescription] pd ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID]
;
GO

CREATE UNIQUE CLUSTERED INDEX [IX_vProductAndDescription] ON [Production].[vProductAndDescription]
(
	[CultureID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/*******************************************************************************************
-- Now to look at some queries
*******************************************************************************************/
-- Query the view by itself
SELECT ProductID, Name, ProductModel, CultureID, Description
FROM Production.vProductAndDescription;




-- Part of a single Join
SELECT sod.ModifiedDate, v.ProductID, sod.OrderQty, v.Name, v.ProductModel, v.CultureID, v.Description
FROM Sales.SalesOrderDetail as sod 
	JOIN Production.vProductAndDescription as v ON v.ProductID = sod.ProductID
;




-- adding another table
SELECT TerritoryID, soh.SalesOrderNumber, v.ProductID, sod.OrderQty, 
	v.Name, v.ProductModel, v.Description, v.CultureID, v.Description
FROM Sales.SalesOrderHeader as soh
	JOIN Sales.SalesOrderDetail as sod ON sod.SalesOrderID = soh.SalesOrderID
	JOIN Production.vProductAndDescription as v ON v.ProductID = sod.ProductID
WHERE TerritoryID = 1
;



GO
-- end of script