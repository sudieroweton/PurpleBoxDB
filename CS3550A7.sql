--Sudie Roweton
--CS 3550 Spring 2016 
--Assignment #7 : Stored Procedures

USE PurpleBox;
GO
---------------------------------------------------------------
--Adding a new movie, actor, director, and genre in preparation
-- as per requirement 1.c
---------------------------------------------------------------
INSERT INTO PbMovie
(movieID, movieTitle, movieKeywords, lastChangedBy, lastChangedOn)
VALUES
('mamb911', 'A Beautiful Mind','mathematician, conspiracy, cryptography, John Nash','smr',GETDATE());

INSERT INTO PbGenre
(genre, lastChangedBy, lastChangedOn)
VALUES
('biography', 'smr', GETDATE());

INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Russell','Crowe','smr',GETDATE());

INSERT INTO PbDirector
(dFirstName, dLastName, lastChangedBy, lastChangedOn)
VALUES
('Ron','Howard','smr',GETDATE());


---------------------------------------
--Drop Statements (requirement 1.b)
---------------------------------------
IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addPhone')

		DROP PROCEDURE usp_addPhone;
GO

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addQuestion')

		DROP PROCEDURE usp_addQuestion;
GO

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieGenre')

		DROP PROCEDURE usp_addMovieGenre;
GO

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieDirector')

		DROP PROCEDURE usp_addMovieDirector;
GO

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieActor')

		DROP PROCEDURE usp_addMovieActor;
GO


--Stored Procedures : Requirement 1.a

---------------------------------------
--Stored Procedure : PbPhone
---------------------------------------

CREATE PROCEDURE usp_addPhone
	@phoneNumber nvarchar(30),
	@pbUserID nvarchar(10)
AS
BEGIN --{
	
	DECLARE @pbUser_id int;

	SELECT @pbUser_id = pbUser_id
	FROM PbUser
	WHERE pbUserID = @pbUserID;
	
	IF (@pbUser_id IS NULL)
		BEGIN
			RAISERROR('Invalid User ID',0,1);
			RETURN 1;
		END

	BEGIN TRY
		INSERT INTO PbPhone
			(pbUserID, phoneNumber, pbUser_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@pbUserID, @phoneNumber, @pbUser_id, 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH

END --}
GO ---need a GO
---------------------------------------
--Stored Procedure : PbQuestion
---------------------------------------
CREATE PROCEDURE usp_addQuestion
	@pbUserID nvarchar(10),
	@question nvarchar(255),
	@answer nvarchar(255)
AS
BEGIN
	DECLARE @pbUser_id int;

	SELECT @pbUser_id = pbUser_id
	FROM PbUser
	WHERE pbUserID = @pbUserID;

		IF (@pbUser_id IS NULL)
		BEGIN
			RAISERROR('Invalid User ID',0,1);
			RETURN 1;
		END
	BEGIN TRY
		INSERT INTO PbQuestion
			(pbUserID, question, answer, pbUser_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@pbUserID, @question, @answer, @pbUser_id, 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH
END
GO
---------------------------------------
--Stored Procedure : PbMovieGenre
---------------------------------------
CREATE PROCEDURE usp_addMovieGenre
	@movieID nvarchar(10),
	@genre nvarchar(20)
AS
BEGIN --{
	
	DECLARE @pbMovie_id int;
	DECLARE @pbGenre_id int;

	SELECT @pbMovie_id = pbMovie_id
	FROM PbMovie
	WHERE movieID = @movieID;

	SELECT @pbGenre_id = pbGenre_id
	FROM PbGenre
	WHERE genre = @genre;
	
	IF (@pbMovie_id IS NULL)
		BEGIN
			RAISERROR('Invalid Movie ID',0,1);
			RETURN 1;
		END
	
	IF (@pbGenre_id IS NULL)
		BEGIN
			RAISERROR('Invalid Genre ID',0,1);
			RETURN 1;
		END


	BEGIN TRY
		INSERT INTO PbMovieGenre
			(movieID, genre, pbMovie_id, pbGenre_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@movieID, @genre, @pbMovie_id,@pbGenre_id, 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH

END --}
GO ---need a GO
---------------------------------------
--Stored Procedure : PbMovieDirector
---------------------------------------
CREATE PROCEDURE usp_addMovieDirector
	@movieID nvarchar(10),
	@dFirstName nvarchar(50),
	@dLastName nvarchar(50)
AS
BEGIN --{
	
	DECLARE @pbMovie_id int;
	DECLARE @pbDirector_id int;

	SELECT @pbMovie_id = pbMovie_id
	FROM PbMovie
	WHERE movieID = @movieID;

	SELECT @pbDirector_id = pbDirector_id
	FROM PbDirector
	WHERE dFirstName = @dFirstName	
		AND dLastName = @dLastName;
	
	IF (@pbMovie_id IS NULL)
		BEGIN
			RAISERROR('Invalid Movie ID',0,1);
			RETURN 1;
		END
	
	IF (@pbDirector_id IS NULL)
		BEGIN
			RAISERROR('Invalid Director ID',0,1);
			RETURN 1;
		END


	BEGIN TRY
		INSERT INTO PbMovieDirector
			(movieID, dFirstName, dLastName, pbMovie_id, pbDirector_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@movieID, @dFirstName, @dLastName, @pbMovie_id,@pbDirector_id, 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH

END --}
GO ---need a GO
---------------------------------------
--Stored Procedure : PbMovieActor
---------------------------------------
CREATE PROCEDURE usp_addMovieActor
	@movieID nvarchar(10),
	@aFirstName nvarchar(50),
	@aLastName nvarchar(50)
AS
BEGIN --{
	
	DECLARE @pbMovie_id int;
	DECLARE @pbActor_id int;

	SELECT @pbMovie_id = pbMovie_id
	FROM PbMovie
	WHERE movieID = @movieID;

	SELECT @pbActor_id = pbActor_id
	FROM PbActor
	WHERE aFirstName = @aFirstName	
		AND aLastName = @aLastName;
	
	IF (@pbMovie_id IS NULL)
		BEGIN
			RAISERROR('Invalid Movie ID',0,1);
			RETURN 1;
		END
	
	IF (@pbActor_id IS NULL)
		BEGIN
			RAISERROR('Invalid Actor ID',0,1);
			RETURN 1;
		END


	BEGIN TRY
		INSERT INTO PbMovieActor
			(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@movieID, @aFirstName, @aLastName, @pbMovie_id,@pbActor_id, 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH

END --}
GO ---need a GO

---------------------------------------
--Execute Statements to insert rows (Requirement 2)
---------------------------------------
EXECUTE usp_addPhone '970-241-5508', 'kf1234';
EXECUTE usp_addQuestion 'rr4417', 'Favorite dessert?','tiramisu';
EXECUTE usp_addMovieGenre 'mamb911', 'biography';
EXECUTE usp_addMovieDirector 'mamb911','Ron','Howard';
EXECUTE usp_addMovieActor 'mamb911','Russell','Crowe';

--------------------------------------------
--SQL SELECT Statements to display contents
-- of tables that had rows inserted (Requirement 3)
--------------------------------------------
SELECT * FROM PbPhone;
SELECT * FROM PbQuestion;
SELECT * FROM PbMovieGenre;
SELECT * FROM PbMovieDirector;
SELECT * FROM PbMovieActor;

---------------------------------------------
--SQL DELETE Statements to display contents
-- of tables that had rows inserted (Requirement 4)
---------------------------------------------
--Delete those rows inserted via stored procedures
DELETE FROM PbMovieGenre
	WHERE movieID = 'mamb911'
		AND genre = 'biography';

DELETE FROM PbMovieDirector
	WHERE movieID = 'mamb911'
		AND dFirstName = 'Ron'
		AND dLastName = 'Howard';

DELETE FROM PbMovieActor
	WHERE movieID = 'mamb911'
		AND aFirstName = 'Russell'
		AND aLastName = 'Crowe';

DELETE FROM PbPhone	
	WHERE phoneNumber = '970-241-5508'
		AND pbUserID= 'kf1234';

DELETE FROM PbQuestion	
	WHERE question = 'Favorite dessert?'
		AND pbUserID= 'rr4417';


--Deleting the rows that were inserted via preparation for the stored procedures
DELETE FROM PbMovie
	WHERE movieID = 'mamb911';

DELETE FROM PbActor
	WHERE aFirstName = 'Russell'
		AND aLastName = 'Crowe';

DELETE FROM PbDirector	
	WHERE dFirstName = 'Ron'
		AND dLastName = 'Howard';

DELETE FROM PbGenre	
	WHERE genre = 'biography'; 


