/*******************************
Connect to SQL 2017 Instance
*******************************/


USE DebsAdventureWorks
GO

/*******************************
User Defined Functions:

1. Confirm you are in the right database 
2. Set STATISTCS IO on
3. Include the Actual Execution Plan (Ctrl + M)
4. Note the differences in Properties
*******************************/

SET STATISTICS IO ON
GO

/******************************************
Multi-Statement Table Value Functions

THese are the same queries that we look at with SQL 2016
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

/*
-------------------------------------
-------------------------------------
-------------------------------------
--
-- What happened? 
-- https://blogs.msdn.microsoft.com/sqlserverstorageengine/2017/04/19/introducing-interleaved-execution-for-multi-statement-table-valued-functions/
-------------------------------------
-------------------------------------
-------------------------------------
*/


/*******************************************
-- Look at new udf - ufn_SalesPersonTerritories
*******************************************/

-- Deb's function to test SQL 2017 Interleaved Execution
CREATE FUNCTION [demo].[ufn_SalesPersonTerritories]()
RETURNS 
	@SalesPersonTerritory TABLE 
	(PersonID integer, JobTitle nvarchar(100), TerritoryLists varchar(100))
AS
BEGIN

INSERT INTO @SalesPersonTerritory (PersonID, JobTitle, TerritoryLists)
SELECT p.BusinessEntityID, e.JobTitle, st.Name as TerritoryName 
FROM Person.Person as p
    INNER JOIN [HumanResources].[Employee] as e ON e.[BusinessEntityID] = p.[BusinessEntityID]
	INNER JOIN [Sales].[SalesPerson] as s ON p.BusinessEntityID = s.BusinessEntityID
	LEFT OUTER JOIN [Sales].[SalesTerritory] as st ON st.[TerritoryID] = s.[TerritoryID]

RETURN;

END
GO

/******************************************
Now let's look at a query
******************************************/

SELECT p.FirstName, p.LastName, udf.JobTitle, udf.TerritoryLists 
FROM Person.Person as p
	JOIN Demo.ufn_SalesPersonTerritories() as udf ON p.BusinessEntityID = udf.PersonID
;

GO
-- end of script