use Superheroes;
GO

SELECT AllocUnitName, Operation, Context, [Page ID], [Transaction ID], [Parent Transaction ID], [Current LSN], [Previous LSN]
	--, * 
FROM fn_dblog(NULL,NULL)
WHERE AllocUnitName LIKE '%Alter_Ego%'