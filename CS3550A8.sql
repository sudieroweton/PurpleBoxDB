--Sudie Roweton
--CS 3550
--Assignment 8 : Views, Functions, & Triggers

USE PurpleBox
GO
--Drop Statements

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbRentalHistory'
) DROP TABLE PbRentalHistory;
GO
IF EXISTS(
	SELECT * FROM sysobjects WHERE id = object_id(N'udf_getUserID'))
	DROP FUNCTION dbo.udf_getUserID;
GO

IF EXISTS(
	SELECT * FROM sysobjects WHERE id = object_id(N'udf_getMovieItemID'))
	DROP FUNCTION dbo.udf_getMovieItemID;
GO

IF EXISTS(
	SELECT * FROM sysobjects WHERE id = object_id(N'udt_rentalHistory'))
	DROP TRIGGER dbo.udt_rentalHistory;
GO
IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addRequest')

		DROP PROCEDURE usp_addRequest;
GO

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addRental')

		DROP PROCEDURE usp_addRental;
GO


IF EXISTS(
	SELECT * FROM sysobjects WHERE id = object_id(N'udv_rentalsDue'))
	DROP VIEW dbo.udv_rentalsDue;
GO
---------------------------------
--Functions
---------------------------------
--udf_getUserID : returns pbUser_id when given pbUserID

CREATE FUNCTION udf_getUserID(@pbUserID nvarchar(10))
RETURNS INT
BEGIN
	DECLARE @pbUser_id INT;
	
	SELECT @pbUser_id = pbUser_id
	FROM PbUser
	WHERE pbUserID = @pbUserID;

	RETURN @pbUser_id;

END
GO

--udf_getMovieItemID : returns pbMovieItem_id when given movieItemID
CREATE FUNCTION udf_getMovieItemID(@movieItemID nvarchar(10))
RETURNS INT
BEGIN
	DECLARE @pbMovieItem_id INT;
	
	SELECT @pbMovieItem_id = pbMovieItem_id
	FROM PbMovieItem
	WHERE movieItemID = @movieItemID;

	RETURN @pbMovieItem_id;
END
GO

---------------------------------
--pbRentalHistory Table Creation
---------------------------------
CREATE TABLE PbRentalHistory(
		pbRentalHistory_id int NOT NULL IDENTITY(1000000000,1),
		pbUser_id int NOT NULL,
		pbMovieItem_id int NOT NULL,
		rentalDate datetime NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);
GO
---------------------------------
--Triggers
---------------------------------
CREATE TRIGGER dbo.udt_rentalHistory
ON PbRental
AFTER INSERT
AS
BEGIN
	INSERT INTO PbRentalHistory	
		(pbUser_id, pbMovieItem_id, rentalDate, lastChangedBy, lastChangedOn)
		(SELECT pbUser_id, pbMovieItem_id, rentalDate, lastChangedBy, lastChangedOn
		 FROM inserted)	 
END
GO

---------------------------------
--Stored Procedures
---------------------------------
--addRequest Procedure
CREATE PROCEDURE usp_addRequest
	@pbUserID nvarchar(10),
	@movieItemID nvarchar(10),
	@requestDate datetime
AS
BEGIN --{
	
	DECLARE @pbUser_id int;
	DECLARE @pbMovieItem_id int;
	DECLARE @custType varchar(3);
	DECLARE @ntype varchar(3);
	DECLARE @ptype varchar(3);

	SET @ntype = 'N';
	SET @ptype = 'P';
	
	SELECT @custType = custType
	FROM PbUser
	WHERE pbUserID = @pbUserID;

	IF @custType = @ntype
		BEGIN
			RAISERROR('Normal Customers Cannot Request',0,1);
			RETURN 1;
		END
	
	IF @custType = @ptype
		BEGIN

			IF((SELECT COUNT(*)
				FROM PbRequest
				WHERE pbUserID = @pbUserID) >= 4)
				BEGIN
					RAISERROR('Too many requests',0,1);
					RETURN 1;
				END

		END

	BEGIN TRY
		INSERT INTO PbRequest
			(pbUserID, movieItemID, requestDate, pbUser_id, pbMovieItem_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@pbUserID, @movieItemID, @requestDate,dbo.udf_getUserID(@pbUserID), dbo.udf_getMovieItemID(@movieItemID), 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH

END
GO 

--addRental Procedure
CREATE PROCEDURE usp_addRental
	@pbUserID nvarchar(10),
	@movieItemID nvarchar(10),
	@rentalDate datetime,
	@dueDate datetime
AS
BEGIN 
	
	DECLARE @pbUser_id int;
	DECLARE @pbMovieItem_id int;
	DECLARE @custType varchar(3);
	DECLARE @ntype varchar(3);
	DECLARE @ptype varchar(3);

	SET @ntype = 'N';
	SET @ptype = 'P';
	
	SELECT @custType = custType
	FROM PbUser
	WHERE pbUserID = @pbUserID;

	IF @custType = @ntype
		BEGIN
				IF((SELECT COUNT(*)
				FROM PbRental
				WHERE pbUserID = @pbUserID
					AND returnDate IS NULL) >= 2)
				BEGIN
					RAISERROR('Too Many Rentals',0,1);
					RETURN 1;
				END
		END
	
	IF @custType = @ptype
		BEGIN

			IF((SELECT COUNT(*)
				FROM PbRental
				WHERE pbUserID = @pbUserID
					AND returnDate IS NULL) >= 4)
				BEGIN
					RAISERROR('Too Many Rentals',0,1);
					RETURN 1;
				END

		END

	BEGIN TRY
		INSERT INTO PbRental
			(pbUserID, movieItemID, rentalDate, dueDate, returnDate, pbUser_id, pbMovieItem_id, lastChangedBy, lastChangedOn)
		VALUES 
			(@pbUserID, @movieItemID, @rentalDate,@dueDate, NULL, dbo.udf_getUserID(@pbUserID), dbo.udf_getMovieItemID(@movieItemID), 'smr', GETDATE());
	END TRY
	BEGIN CATCH
		RAISERROR('Insert statement failed',0,2);
	END CATCH

END
GO 
---------------------------------
--View
---------------------------------
CREATE VIEW udv_rentalsDue
AS
	SELECT mi.movieItemID, mo.movieTitle, ur.pbUserID, ur.userFirstName, ur.userLastName, mr.rentalDate, mr.dueDate
	FROM PbMovie mo INNER JOIN PbMovieItem mi
		ON mo.pbMovie_id = mi.pbMovie_id
		INNER JOIN PbRental mr
		ON mi.pbMovieItem_id = mr.pbMovieItem_id
		INNER JOIN PbUser ur
		ON mr.pbUser_id = ur.pbUser_id;


--SELECT m.movieTitle, a.aFirstName, a.aLastName  
--FROM PbMovie m INNER JOIN PbMovieActor ma
--	ON m.pbMovie_id = ma.pbMovie_id
--	INNER JOIN pbActor a
--	ON ma.pbActor_id = a.pbActor_id ;
GO

---------------------------------
--SQL Statements
---------------------------------

---------------------------------------
--Call request procedure : valid
---------------------------------------
-------PREMIUM CUSTOMER
EXECUTE usp_addRequest 'kf1234','mith1', '2016-03-09';  
EXECUTE usp_addRequest 'kf1234','mith2', '2016-03-09'; 
EXECUTE usp_addRequest 'kf1234','migg1', '2016-03-09'; 
EXECUTE usp_addRequest 'kf1234','migg2', '2016-03-09'; 
---------------------------------------
--Call request procedure : invalid
---------------------------------------
------NORMAL CUSTOMER (try to request but requests are denied for normal customers)
EXECUTE usp_addRequest 'rr4417','mith1', '2016-03-09'; 

-----PREMIUM CUSTOMER (try to add one more request but limit is 4) 
EXECUTE usp_addRequest 'kf1234','mibs1', '2016-03-09'; 

----------------------------------------
--Call rental routine : valid
----------------------------------------
-----PREMIUM CUSTOMER
EXECUTE usp_addRental 'kf1234','mith1', '2016-03-09','2016-03-14';
EXECUTE usp_addRental 'kf1234','mith2', '2016-03-09','2016-03-14';
EXECUTE usp_addRental 'kf1234','migg1', '2016-03-09','2016-03-14';
EXECUTE usp_addRental 'kf1234','migg2', '2016-03-09','2016-03-14';

-----NORMAL CUSTOMER
EXECUTE usp_addRental 'rr4417','mith1', '2016-03-09','2016-03-14';
EXECUTE usp_addRental 'rr4417','mith2', '2016-03-09','2016-03-14';

-------------------------------------
--Call rental routine : invalid
-------------------------------------
--------PREMIUM CUSTOMER (try to add one more beyond the limit of 4)
EXECUTE usp_addRental 'kf1234','mibs1', '2016-03-09','2016-03-14';

--------NORMAL CUSTOMER (try to add one more beyond the limit of 2)
EXECUTE usp_addRental 'rr4417','migg1', '2016-03-09','2016-03-14';

--Query request and rental tables
SELECT * 
FROM PbRequest;

SELECT *
FROM PbRental;

SELECT *
FROM PbRentalHistory;

--Query rental history view (udv_rentalsDue)
SELECT *
FROM dbo.udv_rentalsDue;


---------------------------------
--Clean Up
---------------------------------

DELETE FROM PbRental
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'mith1'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000000'
		AND pbmovieItem_id = '1000000000'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRental
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'mith2'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000000'
		AND pbmovieItem_id = '1000000001'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRental
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'migg1'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000000'
		AND pbmovieItem_id = '1000000002'
		AND rentalDate = '2016-03-09';
GO


DELETE FROM PbRental
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'migg2'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000000'
		AND pbmovieItem_id = '1000000003'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRental
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'mibs1'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000000'
		AND pbmovieItem_id = '1000000004'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRental
	WHERE pbUserID = 'rr4417'
		AND movieItemID = 'mith1'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000001'
		AND pbmovieItem_id = '1000000000'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRental
	WHERE pbUserID = 'rr4417'
		AND movieItemID = 'mith2'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000001'
		AND pbmovieItem_id = '1000000001'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRental
	WHERE pbUserID = 'rr4417'
		AND movieItemID = 'migg1'
		AND rentalDate = '2016-03-09';
GO

DELETE FROM PbRentalHistory
	WHERE pbUser_id = '1000000001'
		AND pbmovieItem_id = '1000000002'
		AND rentalDate = '2016-03-09';
GO


SELECT * FROM pbRequest;
DELETE FROM PbRequest
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'mith1'
		AND requestDate = '2016-03-09';
GO
DELETE FROM PbRequest
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'mith2'
		AND requestDate = '2016-03-09';
GO
DELETE FROM PbRequest
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'migg1'
		AND requestDate = '2016-03-09';
GO
DELETE FROM PbRequest
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'migg2'
		AND requestDate = '2016-03-09';
GO
DELETE FROM PbRequest
	WHERE pbUserID = 'kf1234'
		AND movieItemID = 'mibs1'
		AND requestDate = '2016-03-09';
GO


