USE Superheroes
GO

INSERT INTO Villain.Gadget (Gadget_Name, Gadget_Desc)
SELECT Gadget_Name, CASE WHEN Datalength(Gadget_Name) < 11 THEN Gadget_Desc ELSE NULL END
FROM dbo.Gadget
GO

INSERT INTO Villain.Gadget (Gadget_Name, Gadget_Desc)
VALUES (NULL, NULL)
GO 3

INSERT INTO Villain.Gadget
SELECT Gadget_Name, CASE WHEN Datalength(Gadget_Name) < 8 THEN Gadget_Desc ELSE NULL END
FROM dbo.Gadget
WHERE Datalength(Gadget_Name) < 11 
GO


