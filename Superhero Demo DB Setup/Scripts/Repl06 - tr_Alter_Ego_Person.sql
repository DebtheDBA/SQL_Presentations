USE Superheroes_Repl
GO

CREATE OR ALTER TRIGGER tr_Alter_Ego_Person ON dbo.Alter_Ego_Person
FOR INSERT,UPDATE,DELETE 
AS
BEGIN

	DECLARE @message VARCHAR(50)

	SELECT @message = 'Alter_Ego_Person - Inserted: ' + CONVERT(VARCHAR(10), MAX(Inserted)) + '; Deleted: ' + CONVERT(VARCHAR(10), MAX(Deleted))
	FROM (
		SELECT COUNT(*) AS Inserted, NULL AS Deleted FROM Inserted
		UNION ALL
		SELECT NULL AS Inserted, COUNT(*) AS Deleted FROM Deleted
		) AS changecounts

	INSERT INTO dbo.Trigger_Replication_Log (LogMessage)
	VALUES (@message)

END
GO