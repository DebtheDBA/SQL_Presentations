USE [DebsAdventureWorks]
GO

/*******************************************************************************************
Derived tables

Instructions:
* Turn on Actual Execution Plans (Ctrl+M) before running the queries on this page.
*******************************************************************************************/

-- Single Derived Table
SELECT 	c.CustomerID, 
	c.AccountNumber, 
	c.StoreID, 
	c.TerritoryID,
	soh.SalesPersonID,
	details.NumberOfShipments,
	details.TotalQuantity,
	details.WeightedAvgPrice,
	details.AvgOrderQty,
	details.MaxOrderQty,
	details.MinOrderQty
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
;

/*******************************************************************************************/

-- "Nested" derived tables
-- In the execution plan, note how the tables in the subqueries are grouped 
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
				) details ON soh.SalesOrderID = details.SalesOrderID
		GROUP BY c.CustomerID, c.AccountNumber, c.StoreID, c.TerritoryID,soh.SalesPersonID
	) orders ON orders.SalesPersonID = sp.BusinessEntityID
;

GO

-- end of script