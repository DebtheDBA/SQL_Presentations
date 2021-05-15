USE Superheroes_Repl
GO

CREATE OR ALTER TRIGGER tr_Person ON dbo.Person
FOR INSERT,UPDATE,DELETE 
AS
BEGIN

	DECLARE @message VARCHAR(50)

	SELECT @message = 'Person - Inserted: ' + CONVERT(VARCHAR(10), MAX(Inserted)) + '; Deleted: ' + CONVERT(VARCHAR(10), MAX(Deleted))
	FROM (
		SELECT COUNT(*) AS Inserted, NULL AS Deleted FROM Inserted
		UNION ALL
		SELECT NULL AS Inserted, COUNT(*) AS Deleted FROM Deleted
		) AS changecounts

	INSERT INTO dbo.Trigger_Replication_Log (LogMessage)
	VALUES (@message)

END
GO