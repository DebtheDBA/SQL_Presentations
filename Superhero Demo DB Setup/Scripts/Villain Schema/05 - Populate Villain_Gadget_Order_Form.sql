USE Superheroes
GO


INSERT INTO Villain.Gadget_Order_Form 
	(Order_Date, Person_ID, Gadget_ID, Number_Ordered, Price_Per_Item)
SELECT
	getdate() as Order_Date,
	p.Person_ID as Person_ID,
	g.Gadget_ID as Gadget_ID,
	CASE WHEN Datalength(Gadget_Name) = 10 THEN Datalength(Gadget_Name)  / 1.5 
		WHEN Datalength(Gadget_Name) < 11 THEN Datalength(Gadget_Name) 
		ELSE g.Gadget_ID + datalength(p.Last_Name)
	END as Number_Ordered,
	CASE WHEN Datalength(Gadget_Name) < 11 THEN Datalength(p.Last_Name) 
		ELSE g.Gadget_ID + datalength(ISNULL(g.Gadget_Name, p.Person_ID))
	END * 10.50 as Price_Per_Item
FROM Villain.Gadget as G
	JOIN Person as P ON Person_ID * 3 - 1 = G.Gadget_ID

-- update using the data from the columns
UPDATE Villain.Gadget_Order_Form
SET Tax = Number_Ordered * Price_Per_Item * .0565, -- taxrate of 5.65%
	Shipping = Number_Ordered * 10.000, -- $10 per item flat rate
	Total_Due = (Number_Ordered * Price_Per_Item) + (Number_Ordered * Price_Per_Item * .0565) + (Number_Ordered * 10.000)


-- move data in from good order form
INSERT INTO Villain.Gadget_Order_Form
	(
	Order_Date,
	Person_ID,
	Corporation_ID,
	Gadget_ID,
	Number_Ordered,
	Price_Per_Item,
	Tax,
	Shipping,
	Total_Due
	)
SELECT 
	g1.Order_Date,
	g1.Person_ID,
	g1.Corporation_ID,
	g1.Gadget_ID,
	g1.Number_Ordered,
	g1.Price_Per_Item,
	g1.Tax,
	g1.Shipping,
	g1.Total_Due
FROM dbo.Gadget_Order_Form as g1
	CROSS JOIN dbo.Gadget_Order_Form as g2
ORDER BY g1.Gadget_ID
GO 

-- Add the cleaned up version of these values to the dbo schema
INSERT INTO dbo.Gadget_Order_Form (
	Order_Date,
	Person_ID,
	--Corporation_ID,
	Gadget_ID,
	Number_Ordered,
	Price_Per_Item,
	Tax,
	Shipping,
	Total_Due
	)
SELECT Order_Date, Person_ID, Gadget_ID,
	Number_Ordered, Price_Per_Item,
	convert(decimal(19, 2), Number_Ordered * Price_Per_Item * .0565) as Tax, -- taxrate of 5.65%
	convert(decimal(19, 2), Number_Ordered * 10.000) as Shipping, -- $10 per item flat rate
	convert(decimal(19, 2), (Number_Ordered * Price_Per_Item) + (Number_Ordered * Price_Per_Item * .0565) + (Number_Ordered * 10.000)) as Total_Due 
FROM (
	SELECT distinct Order_Date, Person_ID, g.Gadget_ID, 
		convert(int, Number_Ordered) as Number_Ordered,
		convert(decimal(19,2), Price_Per_Item) as Price_Per_Item
	FROM Villain.Gadget_Order_Form as vgof
		JOIN Villain.Gadget as vg ON vgof.Gadget_ID = vg.Gadget_ID
		JOIN dbo.Gadget as g ON vg.Gadget_Name = g.Gadget_Name
	WHERE NOT EXISTS 
		(SELECT * FROM dbo.Gadget_Order_Form as gof
		WHERE gof.Order_Date = vgof.Order_Date
		AND gof.Person_ID = vgof.Person_ID
		AND gof.Gadget_ID = g.Gadget_ID)
	) as Cleaned_Up_Orders
