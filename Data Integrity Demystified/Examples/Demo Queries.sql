USE Superheroes
GO

-- Turn on the Execution Plan (Ctrl + M) first

/*****************************************************
*****************************************************
How do constraints play into execution plans and performance?
*****************************************************
******************************************************/

/*****************************************************
 Where does the NULL or NOT NULL play into the execution plan?
*****************************************************/

-- In the dbo schema, Gadget_Order_Form.Shipping IS NOT NULL
SELECT VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item,
       VG.Tax,
       VG.Shipping,
       (VG.Number_Ordered * VG.Price_Per_Item) + VG.Tax + VG.Shipping AS Calculated_Total,
       VG.Total_Due
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN dbo.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
WHERE VG.Shipping IS NOT NULL;

-- Now search for Shipping Is NULL
SELECT VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item,
       VG.Tax,
       VG.Shipping,
       (VG.Number_Ordered * VG.Price_Per_Item) + VG.Tax + VG.Shipping AS Calculated_Total,
       VG.Total_Due
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN dbo.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
WHERE VG.Shipping IS NULL;







/*****************************************************
 Focus in on the Primary Key Constraint... 
*****************************************************/

SELECT VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item,
       VG.Tax,
       VG.Shipping,
       (VG.Number_Ordered * VG.Price_Per_Item) + VG.Tax + VG.Shipping AS Calculated_Total,
       VG.Total_Due
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN dbo.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
WHERE p.Person_ID = 10;


/*****************************************************
 Now let's look at Unique Constraints!
*****************************************************/

-- let's create a Villain table for equipment
CREATE TABLE Villain.Equipment
(
    Equipment_ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    Equipment_Name VARCHAR(30) NULL
);

-- insert the data from Gadget plus 1 NULL value
INSERT INTO Villain.Equipment
(
    Equipment_Name
)
SELECT Gadget_Name
FROM dbo.Gadget
UNION
SELECT NULL;


-- What happens when I look for that 1 NULL value?
SELECT Equipment_Name
FROM Villain.Equipment
WHERE Equipment_Name IS NULL;

-- Now create the unique constraint
ALTER TABLE Villain.Equipment
ADD CONSTRAINT UQ_Equipment_EquipmentName
    UNIQUE (Equipment_Name);

-- Run the statement again
SELECT Equipment_Name
FROM Villain.Equipment
WHERE Equipment_Name IS NULL;

-- We can test this for an actual value if you want. Are you interested in umbrellas?

-- let's do some clean up.
DROP TABLE Villain.Equipment


/*****************************************************
 How about Foreign Keys?
*****************************************************/
SELECT VG.Order_Date,
       p.First_Name, 
	   p.Last_Name, 
       VG.Number_Ordered,
       VG.Price_Per_Item
FROM Villain.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID;

-- Now run the above statement commenting out the name information

-- Add the foreign key constraint
ALTER TABLE Villain.Gadget_Order_Form
ADD CONSTRAINT FK_VillainGadgetOrder
    FOREIGN KEY (Person_ID)
    REFERENCES dbo.Person (Person_ID);


SELECT *
FROM sys.foreign_keys
WHERE name = 'FK_VillainGadgetOrder';


SELECT 
	vg.Order_Date,
	-- p.First_Name, p.Last_Name, 
	vg.Number_Ordered, 
	vg.Price_Per_Item
FROM Villain.Gadget_Order_Form as VG
	 JOIN dbo.Person as p ON VG.Person_ID = p.Person_ID



-- Let's check something about that column - Is it NULL?
SELECT COLUMN_NAME,
       IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Villain'
      AND TABLE_NAME = 'Gadget_Order_Form';


-- What happens if we make the column NOT NULL?
ALTER TABLE Villain.Gadget_Order_Form ALTER COLUMN Person_ID INT NOT NULL;

-- Run the query...
SELECT vg.Order_Date,
	-- p.First_Name, p.Last_Name, 
	vg.Number_Ordered, 
	vg.Price_Per_Item
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID;




-- reset the table to its villainous self
ALTER TABLE Villain.Gadget_Order_Form ALTER COLUMN Person_ID INT NULL;

ALTER TABLE Villain.Gadget_Order_Form
DROP CONSTRAINT FK_VillainGadgetOrder;




/*****************************************************
 What happens with Check Constraints?
*****************************************************/
-- In the dbo schema, Gadget_Order_Form.Number_Ordered has a Check Constraint
SELECT name,
       OBJECT_NAME(parent_object_id),
       definition
FROM sys.check_constraints;


SELECT VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN dbo.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
WHERE VG.Number_Ordered = 4;


SELECT VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN dbo.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
WHERE VG.Number_Ordered = 10001;



/*****************************************************
Data Types and Implicit Conversions
******************************************************/

-- What do we have in the Villain schema for orders?
-- Let's take a minute to look and discuss these orders
SELECT VG.Order_ID,
       VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       corp.Corporation_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item,
       VG.Tax,
       VG.Shipping,
       VG.Total_Due
FROM Villain.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN Villain.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
    LEFT JOIN dbo.Corporation AS corp
        ON corp.Corporation_ID = VG.Corporation_ID;



-- What do we have in our dbo schema?
SELECT VG.Order_ID,
       VG.Order_Date,
       p.First_Name,
       p.Last_Name,
       corp.Corporation_Name,
       G.Gadget_Name,
       VG.Number_Ordered,
       VG.Price_Per_Item,
       VG.Tax,
       VG.Shipping,
       VG.Total_Due
FROM dbo.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN dbo.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
    LEFT JOIN dbo.Corporation AS corp
        ON corp.Corporation_ID = VG.Corporation_ID;


-- What happens if you add a primary key to Villain.Gadget?
ALTER TABLE Villain.Gadget
ADD CONSTRAINT PK_VillainGadget
    PRIMARY KEY CLUSTERED (Gadget_ID);

ALTER TABLE Villain.Gadget DROP CONSTRAINT PK_VillainGadget; --PRIMARY KEY CLUSTERED (Gadget_ID)

-- What does this mean for performance difference now that we know the orders exist in both places?

-- Just look at the keys: Note that the hash match is still here. 
-- Open expression in Plan Explorer to confirm that the Expression is the implicit conversion
SELECT VG.Order_ID,
       G.Gadget_ID,
       p.Person_ID,
       corp.Corporation_ID
FROM Villain.Gadget_Order_Form AS VG
    JOIN dbo.Person AS p
        ON VG.Person_ID = p.Person_ID
    JOIN Villain.Gadget AS G
        ON VG.Gadget_ID = G.Gadget_ID
    LEFT JOIN dbo.Corporation AS corp
        ON corp.Corporation_ID = VG.Corporation_ID;
