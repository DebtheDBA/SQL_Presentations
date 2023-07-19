USE [DebsAdventureWorks]
GO

/*******************************************************************************************
CTEs

Instructions:
* Turn on Actual Execution Plans (Ctrl+M) before running the queries on this page.
*******************************************************************************************/

SET STATISTICS IO ON;

/*******************************************************************************************
-- Using a CTE instead of derived table
*******************************************************************************************/

-- derived table example from other page.
SELECT sp.BusinessEntityID, sp.SalesQuota,
	orders.CustomerID, orders.AccountNumber, 
	orders.TotalDue, orders.AvgSalesOrderAmt, orders.TotalSalesOrderQuanity,
	orders.WeightedAvgPricePerQty
FROM Sales.SalesPerson as sp
	JOIN (
		SELECT
			c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,
			soh.SalesPersonID,
			SUM(soh.TotalDue) as TotalDue,
			SUM(soh.TotalDue) / COUNT(soh.SalesOrderID) as AvgSalesOrderAmt,
			SUM(details.NumberOfShipments) as TotalNumberOfShipments,
			SUM(details.TotalQuantity) as TotalSalesOrderQuanity,
			SUM(details.WeightedAvgPrice) / COUNT(soh.SalesOrderID) as WeightedAvgPricePerQty
		FROM Sales.Customer as c 
			JOIN Sales.SalesOrderHeader as soh ON soh.CustomerID = c.CustomerID
			JOIN (
				SELECT sod.SalesOrderID,
					COUNT(distinct CarrierTrackingNumber) as NumberofShipments,
					COUNT(distinct ProductID) as NumberofProducts,
					SUM(sod.OrderQty) as TotalQuantity,
					AVG(sod.OrderQty) as AvgQuantityPerProduct,
					SUM(sod.OrderQty * sod.UnitPrice) as SubTotal,
					SUM(sod.UnitPriceDiscount * sod.OrderQty) as TotalUnitDiscount,
					SUM(UnitPrice * sod.OrderQty)/SUM(sod.OrderQty) as WeightedAvgPrice,
					AVG(UnitPrice) as AvgUnitPrice,
					MIN(UnitPrice) as MinUnitPrice,
					MAX(UnitPrice) as MaxUnitPrice,
					AVG(OrderQty) as AvgOrderQty,
					MIN(OrderQty) as MinOrderQty,
					MAX(OrderQty) as MaxOrderQty
				FROM Sales.SalesOrderDetail as sod
				GROUP BY sod.SalesOrderID
				) as details ON soh.SalesOrderID = details.SalesOrderID
		GROUP BY c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,soh.SalesPersonID
	) as orders ON orders.SalesPersonID = sp.BusinessEntityID
;

-- Making the innermost derived table, details, as a CTE
;
WITH details_cte AS
(
	SELECT sod.SalesOrderID,
		COUNT(distinct CarrierTrackingNumber) as NumberofShipments,
		COUNT(distinct ProductID) as NumberofProducts,
		SUM(sod.OrderQty) as TotalQuantity,
		AVG(sod.OrderQty) as AvgQuantityPerProduct,
		SUM(sod.OrderQty * sod.UnitPrice) as SubTotal,
		SUM(sod.UnitPriceDiscount * sod.OrderQty) as TotalUnitDiscount,
		SUM(UnitPrice * sod.OrderQty)/SUM(sod.OrderQty) as WeightedAvgPrice,
		AVG(UnitPrice) as AvgUnitPrice,
		MIN(UnitPrice) as MinUnitPrice,
		MAX(UnitPrice) as MaxUnitPrice,
		AVG(OrderQty) as AvgOrderQty,
		MIN(OrderQty) as MinOrderQty,
		MAX(OrderQty) as MaxOrderQty
	FROM Sales.SalesOrderDetail as sod
	GROUP BY sod.SalesOrderID
)
SELECT sp.BusinessEntityID, sp.SalesQuota,
	orders.CustomerID, orders.AccountNumber, 
	orders.TotalDue, orders.AvgSalesOrderAmt, orders.TotalSalesOrderQuanity,
	orders.WeightedAvgPricePerQty
FROM Sales.SalesPerson as sp
	JOIN (
		SELECT
			c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,
			soh.SalesPersonID,
			SUM(soh.TotalDue) as TotalDue,
			SUM(soh.TotalDue) / COUNT(soh.SalesOrderID) as AvgSalesOrderAmt,
			SUM(details.NumberOfShipments) as TotalNumberOfShipments,
			SUM(details.TotalQuantity) as TotalSalesOrderQuanity,
			SUM(details.WeightedAvgPrice) / COUNT(soh.SalesOrderID) as WeightedAvgPricePerQty
		FROM Sales.Customer as c 
			JOIN Sales.SalesOrderHeader as soh ON soh.CustomerID = c.CustomerID
			JOIN details_cte as details ON soh.SalesOrderID = details.SalesOrderID
		GROUP BY c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,soh.SalesPersonID
	) as orders ON orders.SalesPersonID = sp.BusinessEntityID
;
	
/*******************************************************************************************
-- What's better CTE vs. Temp Table

Create and load the data for the temp table. Then run the previous statement (copied below) at the
a same time as the version using the CTE.
Note the query cost compare with batch and the query stat times of the SELECT statements.

*******************************************************************************************/
-- create the temp table
CREATE TABLE #SalesOrderDetailSummary
(
	SalesOrderID	int NOT NULL
		PRIMARY KEY CLUSTERED,
	NumberOfShipments int NOT NULL,
	NumberOfProducts int NOT NULL,
	TotalQuantity float NOT NULL,
	AvgQuantityPerProduct float NOT NULL,
	SubTotal float NOT NULL,
	TotalUnitDiscount float NOT NULL,
	WeightedAvgPrice float NOT NULL,
	AvgUnitPrice float NOT NULL,
	MinUnitPrice float NOT NULL,
	MaxUnitPrice float NOT NULL,
	AvgOrderQty float NOT NULL,
	MinOrderQty float NOT NULL,
	MaxOrderQty float NOT NULL

);

-- insert the data
INSERT INTO #SalesOrderDetailSummary
SELECT sod.SalesOrderID,
	COUNT(distinct CarrierTrackingNumber) as NumberofShipments,
	COUNT(distinct ProductID) as NumberofProducts,
	SUM(sod.OrderQty) as TotalQuantity,
	AVG(sod.OrderQty) as AvgQuantityPerProduct,
	SUM(sod.OrderQty * sod.UnitPrice) as SubTotal,
	SUM(sod.UnitPriceDiscount * sod.OrderQty) as TotalUnitDiscount,
	SUM(UnitPrice * sod.OrderQty)/SUM(sod.OrderQty) as WeightedAvgPrice,
	AVG(UnitPrice) as AvgUnitPrice,
	MIN(UnitPrice) as MinUnitPrice,
	MAX(UnitPrice) as MaxUnitPrice,
	AVG(OrderQty) as AvgOrderQty,
	MIN(OrderQty) as MinOrderQty,
	MAX(OrderQty) as MaxOrderQty
FROM Sales.SalesOrderDetail as sod
GROUP BY sod.SalesOrderID;

-- SELECT the data
SELECT sp.BusinessEntityID, sp.SalesQuota,
	orders.CustomerID, orders.AccountNumber, 
	orders.TotalDue, orders.AvgSalesOrderAmt, orders.TotalSalesOrderQuanity,
	orders.WeightedAvgPricePerQty
FROM Sales.SalesPerson as sp
	JOIN (
		SELECT
			c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,
			soh.SalesPersonID,
			SUM(soh.TotalDue) as TotalDue,
			SUM(soh.TotalDue) / COUNT(soh.SalesOrderID) as AvgSalesOrderAmt,
			SUM(details.NumberOfShipments) as TotalNumberOfShipments,
			SUM(details.TotalQuantity) as TotalSalesOrderQuanity,
			SUM(details.WeightedAvgPrice) / COUNT(soh.SalesOrderID) as WeightedAvgPricePerQty
		FROM Sales.Customer as c 
			JOIN Sales.SalesOrderHeader as soh ON soh.CustomerID = c.CustomerID
			JOIN #SalesOrderDetailSummary as details ON soh.SalesOrderID = details.SalesOrderID
		GROUP BY c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,soh.SalesPersonID
	) as orders ON orders.SalesPersonID = sp.BusinessEntityID;

	
-- Run with the previous version of the query that uses a CTE
;
WITH details_cte AS
(
	SELECT sod.SalesOrderID,
		COUNT(distinct CarrierTrackingNumber) as NumberofShipments,
		COUNT(distinct ProductID) as NumberofProducts,
		SUM(sod.OrderQty) as TotalQuantity,
		AVG(sod.OrderQty) as AvgQuantityPerProduct,
		SUM(sod.OrderQty * sod.UnitPrice) as SubTotal,
		SUM(sod.UnitPriceDiscount * sod.OrderQty) as TotalUnitDiscount,
		SUM(UnitPrice * sod.OrderQty)/SUM(sod.OrderQty) as WeightedAvgPrice,
		AVG(UnitPrice) as AvgUnitPrice,
		MIN(UnitPrice) as MinUnitPrice,
		MAX(UnitPrice) as MaxUnitPrice,
		AVG(OrderQty) as AvgOrderQty,
		MIN(OrderQty) as MinOrderQty,
		MAX(OrderQty) as MaxOrderQty
	FROM Sales.SalesOrderDetail as sod
	GROUP BY sod.SalesOrderID
)
SELECT sp.BusinessEntityID, sp.SalesQuota,
	orders.CustomerID, orders.AccountNumber, 
	orders.TotalDue, orders.AvgSalesOrderAmt, orders.TotalSalesOrderQuanity,
	orders.WeightedAvgPricePerQty
FROM Sales.SalesPerson as sp
	JOIN (
		SELECT
			c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,
			soh.SalesPersonID,
			SUM(soh.TotalDue) as TotalDue,
			SUM(soh.TotalDue) / COUNT(soh.SalesOrderID) as AvgSalesOrderAmt,
			SUM(details.NumberOfShipments) as TotalNumberOfShipments,
			SUM(details.TotalQuantity) as TotalSalesOrderQuanity,
			SUM(details.WeightedAvgPrice) / COUNT(soh.SalesOrderID) as WeightedAvgPricePerQty
		FROM Sales.Customer as c 
			JOIN Sales.SalesOrderHeader as soh ON soh.CustomerID = c.CustomerID
			JOIN details_cte as details ON soh.SalesOrderID = details.SalesOrderID
		GROUP BY c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,soh.SalesPersonID
	) as orders ON orders.SalesPersonID = sp.BusinessEntityID
;
	
-- Clean up
DROP TABLE #SalesOrderDetailSummary;



/****************************************************************
-- Optional example - calling the cte multiple times in the SELECT statement
****************************************************************/
;
WITH sod_cte AS (
	SELECT sohcop.CustomerID, sohcop.SalesOrderID, sodcop.ProductID, OrderQty
	FROM Sales.SalesOrderDetail as sodcop
			JOIN Sales.SalesOrderHeader as sohcop ON sodcop.SalesOrderID = sohcop.SalesOrderID
	WHERE sohcop.CustomerID = 11019
	) 
SELECT 
	soh.CustomerID, 
	soh.SalesOrderID, 
	sod.ProductID, 
	sod.OrderQty, 
	sod.UnitPrice, 
	sod.UnitPriceDiscount,
	cop.QtyByCustOrderProduct,
	cp.QtyByCustProduct,
	co.QtyByCustOrder,
	c.QtyByCust
FROM Sales.SalesOrderDetail as sod
	JOIN Sales.SalesOrderHeader as soh ON sod.SalesOrderID = soh.SalesOrderID
	JOIN (
		SELECT ctecop.CustomerID, ctecop.SalesOrderID, ctecop.ProductID, SUM(OrderQty) as QtyByCustOrderProduct
		FROM sod_cte as ctecop
		GROUP BY ctecop.CustomerID, ctecop.SalesOrderID, ctecop.ProductID
		) as cop ON soh.CustomerID = cop.CustomerID AND soh.SalesOrderID = cop.SalesOrderID AND sod.ProductID = cop.ProductID
	JOIN (
		SELECT ctecp.CustomerID, ctecp.ProductID, SUM(OrderQty) as QtyByCustProduct
		FROM sod_cte as ctecp
		GROUP BY ctecp.CustomerID, ctecp.ProductID
		) as cp ON soh.CustomerID = cp.CustomerID AND sod.ProductID = cp.ProductID
	JOIN (
		SELECT cteco.CustomerID, cteco.SalesOrderID, SUM(OrderQty) as QtyByCustOrder
		FROM sod_cte as cteco
		GROUP BY cteco.CustomerID, cteco.SalesOrderID
		) as co ON soh.CustomerID = co.CustomerID AND soh.SalesOrderID = co.SalesOrderID
	JOIN (
		SELECT ctec.CustomerID, SUM(OrderQty) as QtyByCust
		FROM sod_cte as ctec
		GROUP BY ctec.CustomerID
		) as c ON soh.CustomerID = c.CustomerID
WHERE soh.CustomerID = 11019
ORDER BY soh.CustomerID, soh.SalesOrderID, sod.ProductID
;


/****************************************************************
-- Hierarchies
****************************************************************/
;
WITH employee_cte AS
(
	SELECT e.BusinessEntityID, e.JobTitle, 
		e.OrganizationNode.ToString() as OrgChart, 
		ManagerBusinessEntityID, 
		ISNULL(e.OrganizationNode.ToString(), '0') as ManagerOrgChart
	FROM HumanResources.Employee as e
	WHERE e.ManagerBusinessEntityID IS NULL

	UNION ALL

	SELECT hre.BusinessEntityID, hre.JobTitle, 
		hre.OrganizationNode.ToString() as OrgChart, 
		hre.ManagerBusinessEntityID, 
		ISNULL(cte.ManagerOrgChart, '') + ' | ' + REPLACE(hre.OrganizationNode.ToString(), '/', '')
	FROM HumanResources.Employee as hre
		JOIN employee_cte as cte ON hre.ManagerBusinessEntityID = cte.BusinessEntityID
)
SELECT cte.BusinessEntityID, cte.JobTitle, 
	p.FirstName, p.LastName,
	cte.ManagerBusinessEntityID, 
	mp.FirstName, mp.LastName,
	cte.ManagerOrgChart
FROM employee_cte as cte
	JOIN Person.Person as p ON cte.BusinessEntityID = p.BusinessEntityID
	LEFT JOIN Person.Person as mp ON cte.ManagerBusinessEntityID = mp.BusinessEntityID
ORDER BY 
	cte.ManagerOrgChart
;

GO


-- end of script
