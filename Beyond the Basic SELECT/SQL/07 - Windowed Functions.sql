USE [DebsAdventureWorks]
GO

/*******************************
Window Functions:

* Look at the Actual Execution Plan
* Set Statistics IO ON 
*******************************/

SET STATISTICS IO ON
GO

/*******************************
-- Row Numbers

* Then change the ORDER BY
* Now add the WHERE and HAVING clauses
*******************************/

-- "Old School"
SELECT a.Name, a.ProductNumber, count(b.ProductNumber) as RowNumber
FROM (
	SELECT Name, ProductNumber 
	FROM Production.Product
	) as a
	LEFT JOIN (
		SELECT Name, ProductNumber 
		FROM Production.Product
		) as b ON a.ProductNumber >= b.ProductNumber
GROUP BY a.Name, a.ProductNumber
ORDER BY a.Name
;

-- "New School"
SELECT Name, ProductNumber, ROW_NUMBER() OVER(ORDER BY ProductNumber) as RowNumber 
FROM Production.Product
ORDER BY Name
;


/*** Change the Order By ***/
-- "Old School"
SELECT a.Name, a.ProductNumber, count(b.ProductNumber) as RowNumber
FROM (
	SELECT Name, ProductNumber 
	FROM Production.Product
	) as a
	LEFT JOIN (
		SELECT Name, ProductNumber 
		FROM Production.Product
		) as b ON a.ProductNumber >= b.ProductNumber
GROUP BY a.Name, a.ProductNumber
ORDER BY count(b.ProductNumber)
;

-- "New School"
SELECT Name, ProductNumber, ROW_NUMBER() OVER(ORDER BY ProductNumber) as RowNumber 
FROM Production.Product
ORDER BY ROW_NUMBER() OVER(ORDER BY ProductNumber)
;


/*** Only return those with the row number under 13 ***/
-- "Old School"
SELECT a.Name, a.ProductNumber, count(b.ProductNumber) as RowNumber
FROM (
	SELECT Name, ProductNumber 
	FROM Production.Product
	) as a
	LEFT JOIN (
		SELECT Name, ProductNumber 
		FROM Production.Product
		) as b ON a.ProductNumber >= b.ProductNumber
GROUP BY a.Name, a.ProductNumber
HAVING count(b.ProductNumber) < 13
ORDER BY count(b.ProductNumber)
;

-- "New School"
SELECT Name, ProductNumber, ROW_NUMBER() OVER(ORDER BY ProductNumber) as RowNumber 
FROM Production.Product
WHERE ROW_NUMBER() OVER(ORDER BY ProductNumber) < 13
ORDER BY ROW_NUMBER() OVER(ORDER BY ProductNumber)
;



-- "New School" Take 2
SELECT Name, ProductNumber, RowNumber
FROM (
	SELECT Name, ProductNumber, ROW_NUMBER() OVER(ORDER BY ProductNumber) as RowNumber 
	FROM Production.Product
	) as foo
WHERE foo.RowNumber < 13
ORDER BY ProductNumber
;

/*************************************
-- Aggregates

-- Note the OVER(PARITION BY) values
*************************************/

SELECT 
	soh.CustomerID, 
	soh.SalesOrderID, 
	sod.ProductID, 
	sod.OrderQty, 
	sod.UnitPrice, 
	sod.UnitPriceDiscount,
	SUM(OrderQty) OVER(PARTITION BY soh.CustomerID, soh.SalesOrderID, sod.ProductID) 
		as QtyByCustOrderProduct,
	SUM(OrderQty) OVER(PARTITION BY soh.CustomerID, sod.ProductID) 
		as QtyByCustProduct,
	SUM(OrderQty) OVER(PARTITION BY soh.CustomerID, soh.SalesOrderID) 
		as QtyByCustOrder,
	SUM(OrderQty) OVER(PARTITION BY soh.CustomerID)
		as QtyByCust
FROM Sales.SalesOrderDetail as sod
	JOIN Sales.SalesOrderHeader as soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.CustomerID = 11019
ORDER BY soh.CustomerID, soh.SalesOrderID, sod.ProductID
;

-- Same query without Windowed Functions
-- Run with the previous query and compare results in the Execution Plan
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
		SELECT sohcop.CustomerID, sohcop.SalesOrderID, sodcop.ProductID, SUM(OrderQty) as QtyByCustOrderProduct
		FROM Sales.SalesOrderDetail sodcop
			JOIN Sales.SalesOrderHeader sohcop ON sodcop.SalesOrderID = sohcop.SalesOrderID
		WHERE sohcop.CustomerID = 11019
		GROUP BY sohcop.CustomerID, sohcop.SalesOrderID, sodcop.ProductID
		) as cop ON soh.CustomerID = cop.CustomerID AND soh.SalesOrderID = cop.SalesOrderID AND sod.ProductID = cop.ProductID
	JOIN (
		SELECT sohcp.CustomerID, sodcp.ProductID, SUM(OrderQty) as QtyByCustProduct
		FROM Sales.SalesOrderDetail sodcp
			JOIN Sales.SalesOrderHeader sohcp ON sodcp.SalesOrderID = sohcp.SalesOrderID
		WHERE sohcp.CustomerID = 11019
		GROUP BY sohcp.CustomerID, sodcp.ProductID
		) as cp ON soh.CustomerID = cp.CustomerID AND sod.ProductID = cp.ProductID
	JOIN (
		SELECT sohco.CustomerID, sohco.SalesOrderID, SUM(OrderQty) as QtyByCustOrder
		FROM Sales.SalesOrderDetail sodco
			JOIN Sales.SalesOrderHeader sohco ON sodco.SalesOrderID = sohco.SalesOrderID
		WHERE sohco.CustomerID = 11019
		GROUP BY sohco.CustomerID, sohco.SalesOrderID
		) as co ON soh.CustomerID = co.CustomerID AND soh.SalesOrderID = co.SalesOrderID
	JOIN (
		SELECT sohc.CustomerID, SUM(OrderQty) as QtyByCust
		FROM Sales.SalesOrderDetail sodc
			JOIN Sales.SalesOrderHeader sohc ON sodc.SalesOrderID = sohc.SalesOrderID
		WHERE sohc.CustomerID = 11019
		GROUP BY sohc.CustomerID
		) as c ON soh.CustomerID = c.CustomerID
WHERE soh.CustomerID = 11019
ORDER BY soh.CustomerID, soh.SalesOrderID, sod.ProductID
;

-- Without Windowed Functions, with CTE
-- Just for fun, compare with the previous two SELECT statements
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



/*************************************
-- Rolling Aggregates
*************************************/

SELECT soh.CustomerID, soh.OrderDate, soh.TotalDue,
	LAG(TotalDue, 1, 0) OVER (PARTITION BY CustomerID ORDER BY OrderDate) 
		as PreviousOrderAmount,
	SUM(TotalDue) OVER(PARTITION BY CustomerID 
						ORDER BY OrderDate
						ROWS UNBOUNDED PRECEDING)
		as CumulativeTotal
FROM Sales.SalesOrderHeader as soh 
WHERE soh.CustomerID >= 11019
ORDER BY soh.CustomerID, soh.OrderDate

GO

-- end of script