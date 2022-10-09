USE Superheroes
GO

CREATE OR ALTER PROCEDURE dbo.Return_The_Catch_All_Search
	@LastName	varchar(50) = NULL,
	@FirstName	varchar(50) = NULL,
	@AlterEgo	varchar(50) = NULL,
	@IncludePastEgos bit = 0, 
	@IncludeAvgCitizen bit	= 1,
	@IncludeOrders	bit = 0,
	@ComicUniverse varchar(50) = NULL,
	@Debug bit = 0
AS
BEGIN

SET NOCOUNT ON

DECLARE @sql nvarchar(max)

SELECT @sql = '
SELECT p.First_Name, p.Last_Name, ae.Alter_Ego_Name' 
+ CASE WHEN @IncludeOrders = 1 
		THEN char(13) + char(10) + char(9) + ', SUM(Total_Due) as All_Orders_Total_Due'
		ELSE ''
	END
+ '
FROM Person as p ' 
+ CASE WHEN @IncludePastEgos = 1 AND @AlterEgo IS NOT NULL 
	THEN 'JOIN 
		(
		SELECT Person_ID, allp.Alter_Ego_ID, aae.Alter_Ego_Name 
		FROM Alter_Ego_Person FOR System_Time ALL as allp 
			JOIN Alter_Ego as aae ON allp.Alter_Ego_ID = aae.Alter_Ego_ID
		) as aaep ON p.Person_ID = aaep.Person_ID  '
	ELSE ''
	END + char(13) + char(10)
+ '	JOIN Alter_Ego_Person as aep ON p.Person_ID = aep.Person_ID
	JOIN Alter_Ego as ae ON ae.Alter_Ego_ID = aep.Alter_Ego_ID'
+ CASE WHEN @ComicUniverse IS NOT NULL 
	THEN char(13) + char(10) + char(9) + 'JOIN Comic_Universe as cu ON ae.Comic_Universe_ID = cu.Comic_Universe_ID'
	ELSE ''
END
+ CASE WHEN @IncludeOrders = 1
	THEN char(13) + char(10) + char(9) + 'LEFT JOIN Gadget_Order_Form as gof ON gof.Person_ID = p.Person_ID '
	ELSE ''
END
+ '
WHERE 1 = 1 ' -- adding this to make it easier to dynamically add WHERE conditions
+ CASE WHEN @LastName IS NOT NULL
	THEN char(13) + char(10) + 'AND p.Last_Name = ''' + TRIM(@LastName) + ''''
	ELSE ''
END
+ CASE WHEN @FirstName IS NOT NULL
	THEN char(13) + char(10) + 'AND p.First_Name = ''' + TRIM(@FirstName) + ''''
	ELSE ''
END
+ CASE WHEN @AlterEgo IS NOT NULL
	THEN char(13) + char(10) + 'AND ' + CASE WHEN @IncludePastEgos = 1 THEN 'aaep' ELSE 'ae' END 
			+ '.Alter_Ego_Name = ''' + TRIM(@AlterEgo) + ''''
	ELSE ''
END
+ CASE WHEN @ComicUniverse IS NOT NULL 
	THEN char(13) + char(10) + 'AND cu.Comic_Universe_Name = ''' + TRIM(@ComicUniverse) + ''''
	ELSE ''
END
+ CASE WHEN @IncludeAvgCitizen = 0
	THEN char(13) + char(10) + 'AND ae.Alter_Ego_Name <> ''Average Citizen'''
	ELSE ''
END 
+ '
GROUP BY p.First_Name, p.Last_Name, ae.Alter_Ego_Name
ORDER BY p.Last_Name'

IF @Debug = 1
	PRINT @sql

EXEC sp_executesql @sql

END
GO