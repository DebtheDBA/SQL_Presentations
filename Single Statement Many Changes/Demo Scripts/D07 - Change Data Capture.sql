USE Superheroes;
GO

/******************************
******************************
 Demo: Change Data Capture
******************************
******************************/

-- Enable CDC
EXECUTE sys.sp_cdc_enable_db;  
GO  

-- enable CDC on Alter_Ego_Person
EXEC sys.sp_cdc_enable_table   
   @source_schema = N'dbo',
   @source_name   = N'Alter_Ego_Person',
   @role_name     = NULL,
   @filegroup_name = N'Primary',
   @supports_net_changes = 0
GO

-------------------------------------------------------------------------
-- let's make some changes....
-------------------------------------------------------------------------

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM dbo.Alter_Ego_Person as aep 
	JOIN dbo.Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN dbo.Alter_Ego as ae 
WHERE (p.First_Name = 'Deborah' AND p.Last_Name = 'Melkin') 
AND ae.Alter_Ego_Name = 'Wonder Woman'

UPDATE aep
SET Alter_Ego_ID = ae.Alter_Ego_ID
FROM dbo.Alter_Ego_Person as aep 
	JOIN dbo.Person as p ON aep.Person_ID = p.Person_ID
	CROSS JOIN dbo.Alter_Ego as ae 
WHERE (p.First_Name = 'Diana' AND p.Last_Name = 'Prince') 
AND ae.Alter_Ego_Name = 'Average Citizen'


-- now, what did CDC capture?

SELECT * FROM cdc.dbo_Alter_Ego_Person_CT

-------------------------------------------------------------------------
-- Let's see if we can get some more data:
-------------------------------------------------------------------------

EXEC sys.sp_cdc_enable_table   
   @source_schema = N'dbo',
   @source_name   = N'Gadget_Order_Form',
   @role_name     = NULL,
   @filegroup_name = N'Primary',
   @supports_net_changes = 0


-- Let's do some changes....

SELECT * FROM cdc.dbo_Gadget_Order_Form_CT

select * 
from dbo.Alter_Ego_Person as aep 
	JOIN dbo.Alter_Ego as ae ON aep.Alter_Ego_ID = ae.Alter_Ego_ID
	JOIN dbo.Person as p ON aep.Person_ID = p.Person_ID
WHERE ae.Alter_Ego_Name = 'Wonder Woman'

SELECT * FROM dbo.Gadget

-------------------------------------------------------------------------
-- Person ID = 10
-------------------------------------------------------------------------

INSERT INTO dbo.Gadget_Order_Form (Person_ID, Gadget_ID, Number_Ordered)
SELECT 10 as Person_ID, Gadget_ID, 1 FROM dbo.Gadget

UPDATE dbo.Gadget_Order_Form
SET Price_Per_Item = 100, Number_Ordered = 2
WHERE Person_ID = 10
AND Gadget_ID = 1

UPDATE dbo.Gadget_Order_Form
SET Price_Per_Item = 20, Number_Ordered = 4
WHERE Person_ID = 10
AND Gadget_ID = 2

UPDATE dbo.Gadget_Order_Form
SET Price_Per_Item = 30, Number_Ordered = 1
WHERE Person_ID = 10
AND Gadget_ID = 3

UPDATE dbo.Gadget_Order_Form
SET Price_Per_Item = 10000, Number_Ordered = 1
WHERE Person_ID = 10
AND Gadget_ID = 4

-- Forgot to figure out shipping, tax and total amounts. Let's do this as one calculation
UPDATE dbo.Gadget_Order_Form
SET Shipping = CASE WHEN Gadget_ID = 4 THEN 0 ELSE 10 END,
	Tax = (Price_Per_Item * Number_Ordered) * .0525,
	Total_Due = (Price_Per_Item * Number_Ordered) 
				+ CASE WHEN Gadget_ID = 4 THEN 0 ELSE 10 END 
				+ (Price_Per_Item * Number_Ordered) * .0525
WHERE Person_ID = 10

SELECT * FROM dbo.Gadget_Order_Form

-- Just kidding - i'm not buying the jet after all....
DELETE FROM dbo.Gadget_Order_Form WHERE Person_ID = 10 and Gadget_ID = 4


-------------------------------------------------------------------------
-- now let's look at the changes in CDC
-------------------------------------------------------------------------
SELECT * FROM cdc.dbo_Gadget_Order_Form_CT

SELECT * FROM dbo.Gadget_Order_Form

-------------------------------------------------------------------------
-- what happens if you disable CDC for the table?
-------------------------------------------------------------------------
EXEC sys.sp_cdc_disable_table   
   @source_schema = N'dbo',
   @source_name   = N'Gadget_Order_Form',
   @capture_instance = 'all'

SELECT * FROM cdc.dbo_Gadget_Order_Form_CT


-- Disable CDC
EXECUTE sys.sp_cdc_disable_db;  
GO  

/***************
 End of Script
***************/
