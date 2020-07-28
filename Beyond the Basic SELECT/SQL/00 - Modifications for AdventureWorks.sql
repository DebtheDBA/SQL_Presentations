/***************************************************
In my examples, I have restored the Adventure Works database to a new database called DebsAdventureWorks.
You can make your own version if you'd like by following the same example.

First, I used the scripts from Jonathan Kehayias at SQL Skills to add additional data to make the data size
a little larger: https://www.sqlskills.com/blogs/jonathan/enlarging-the-adventureworks-sample-databases/

This script will modify the Adventure Works database to make some small changes to the database schema for
the purpose of the demos.
***************************************************/

IF NOT EXISTS (SELECT column_id FROM sys.columns WHERE name = 'ManagerBusinessEntityID' and object_id = OBJECT_ID(N'HumanResources.Employee'))
ALTER TABLE HumanResources.Employee
ADD ManagerBusinessEntityID int NULL
	CONSTRAINT FK_Employee_Person_Manager FOREIGN KEY 
	REFERENCES Person.Person (BusinessEntityID)
GO

IF NOT EXISTS (SELECT index_id FROM sys.indexes WHERE name = 'IX_Employee_ManagerBusinessEntityID' and object_id = OBJECT_ID(N'HumanResources.Employee'))
CREATE INDEX IX_Employee_ManagerBusinessEntityID ON HumanResources.Employee (ManagerBusinessEntityID)
GO

-- Update the ManagerBusinessEntityID to the person who matches the organization node for their ancestor value.
-- SELECT the data first to make sure it works. 
-- Then COMMENT OUT the SELECT and column list and UNCOMMENT the UPDATE statement and just run that portion
SELECT 
	e.BusinessEntityID, ep.FirstName, ep.LastName,
	e.OrganizationNode,
	e.OrganizationNode.ToString(),
	e.OrganizationNode.GetAncestor(1) as ManagerOrgNode,
	m.BusinessEntityID as ManagerBusinessEntityID, mp.FirstName, mp.LastName
-- UPDATE e SET ManagerBusinessEntityID = mp.BusinessEntityID
FROM HumanResources.Employee e
	JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
	JOIN Person.Person ep ON e.BusinessEntityID = ep.BusinessEntityID
	JOIN Person.Person mp ON m.BusinessEntityID = mp.BusinessEntityID
WHERE e.ManagerBusinessEntityID IS NULL
;

-- Set the Manager BusinessEntityID to the CEO where they have an orgnode value but have no manager
-- SELECT the data first to make sure it works. 
-- Then COMMENT OUT the SELECT and UNCOMMENT the UPDATE statement and just run that portion or just
--	highlight the UPDATE through the end of the statement
SELECT e.BusinessEntityID, ep.FirstName, ep.LastName,
	e.OrganizationNode,
	e.OrganizationNode.ToString(),
	e.OrganizationNode.GetAncestor(1) as ManagerOrgNode
-- UPDATE e SET ManagerBusinessEntityID = 1 
FROM HumanResources.Employee e
	JOIN Person.Person ep ON e.BusinessEntityID = ep.BusinessEntityID
WHERE ManagerBusinessEntityID IS NULL
AND OrganizationNode IS NOT NULL
;


/***************************************************
Adding missing indexes needed by queries 
***************************************************/

IF NOT EXISTS (SELECT index_id FROM sys.indexes WHERE name = 'IX_SalesOrderHeader_TerritoryID')
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_TerritoryID] ON [Sales].[SalesOrderHeader] ([TerritoryID])
GO
