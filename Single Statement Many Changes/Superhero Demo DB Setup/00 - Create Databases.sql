USE master;
GO

-- drop the databases if they exist
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Superheroes')
DROP DATABASE Superheroes
;

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Superheroes_Repl')
DROP DATABASE Superheroes_Repl
;


-- create the clean databases
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Superheroes')
CREATE DATABASE Superheroes
;

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Superheroes_Repl')
CREATE DATABASE Superheroes_Repl
;

