--PurpleBoxDVD create script
--CS3550 Spring 2016
--Sudie Roweton

USE master;
GO
----------------------
--Drop DB if exists
----------------------
IF EXISTS(SELECT * FROM sys.sysdatabases where name='PurpleBox')
	DROP DATABASE PurpleBox;
GO
-----------------------
--Create the Database
-----------------------
CREATE DATABASE [PurpleBox]
	ON PRIMARY
	( NAME = N'PurpleBox', FILENAME =
	N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PurpleBox.mdf',
	SIZE = 5120KB , FILEGROWTH = 1024KB )
	LOG ON
( NAME = N'PurpleBox_log', FILENAME =
N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PurpleBox_log.ldf',
SIZE = 2048KB , FILEGROWTH = 10%);

GO

USE PurpleBox;
GO
--------------------------------
--Drop Tables if they exits
--Tables must be dropped in order
--------------------------------
IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbMovieGenre'
) DROP TABLE PbMovieGenre;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbMovieActor'
) DROP TABLE PbMovieActor;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbMovieDirector'	
) DROP TABLE PbMovieDirector;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbRental'
) DROP TABLE PbRental;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbRequest'
) DROP TABLE PbRequest;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbMovieItem'	
) DROP TABLE PbMovieItem;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbPhone'	
) DROP TABLE PbPhone;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbQuestion'	
) DROP TABLE PbQuestion;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbActor'	
) DROP TABLE PbActor;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbDirector'	
) DROP TABLE PbDirector;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbGenre'	
) DROP TABLE PbGenre;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbMovie'
	
) DROP TABLE PbMovie;

IF EXISTS(
	SELECT * FROM sys.tables WHERE name = N'PbUser'	
) DROP TABLE PbUser;





---------------------------------
--Create Tables
---------------------------------

--First create those tables that aren't dependent
CREATE TABLE PbUser(
		pbUser_id int NOT NULL IDENTITY(1000000000,1),
		pbUserID nvarchar(10) NOT NULL,
		userFirstName nvarchar(50) NOT NULL,
		userLastName nvarchar(50) NOT NULL,
		userPassword nvarchar(20) NOT NULL,
		userType varchar(3) NOT NULL,
		custType varchar(3) NOT NULL,
		banStatus varchar(3) NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbMovie(
		pbMovie_id int NOT NULL IDENTITY(1000000000, 1),
		movieID nvarchar(10) NOT NULL,
		movieTitle nvarchar(100) NOT NULL,
		movieKeywords nvarchar(255) NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
		
);

CREATE TABLE PbGenre(
		pbGenre_id int NOT NULL IDENTITY(1000000000, 1),
		genre nvarchar(20) NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbDirector(
		pbDirector_id int NOT NULL IDENTITY(1000000000, 1),
		dFirstName nvarchar(50) NOT NULL,
		dLastName nvarchar(50) NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbActor(
		pbActor_id int NOT NULL IDENTITY(1000000000, 1),
		aFirstName nvarchar(50) NOT NULL,
		aLastName nvarchar(50) NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

--Now dependant table creation

CREATE TABLE PbQuestion(
		pbQuestion_id int NOT NULL IDENTITY(1000000000,1),
		pbUserID nvarchar(10) NOT NULL,
		question nvarchar(255) NOT NULL,
		answer nvarchar(255) NOT NULL,
		pbUser_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL,

);

CREATE TABLE PbPhone(
		pbPhone_id int NOT NULL IDENTITY(1000000000, 1),
		pbUserID nvarchar(10) NOT NULL,
		phoneNumber nvarchar(30) NOT NULL,
		pbUser_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbMovieItem(
		pbMovieItem_id int NOT NULL IDENTITY(1000000000,1),
		movieItemID nvarchar(10) NOT NULL,
		movieID nvarchar(10) NOT NULL,
		copyNum smallint NOT NULL,
		copyFormat varchar(3),
		pbMovie_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbRequest(
		pbRequest_id int NOT NULL IDENTITY(1000000000,1),
		pbUserID nvarchar(10) NOT NULL,
		movieItemID nvarchar(10) NOT NULL,
		requestDate datetime NOT NULL,
		pbUser_id int NOT NULL,
		pbMovieItem_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL,

);

CREATE TABLE PbRental(
		pbRental_id int NOT NULL IDENTITY(1000000000,1),
		pbUserID nvarchar(10) NOT NULL,
		movieItemID nvarchar(10) NOT NULL,
		rentalDate datetime NOT NULL,
		dueDate datetime NOT NULL,
		returnDate datetime NULL,
		pbUser_id int NOT NULL,
		pbMovieItem_id int NOT NULL,
		lastChangedBy nvarchar(10),
		lastChangedOn datetime NOT NULL

);

CREATE TABLE PbMovieDirector(
		pbMovieDirector_id int NOT NULL IDENTITY(1000000000,1),
		movieID nvarchar(10) NOT NULL,
		dFirstName nvarchar(50) NOT NULL,
		dLastName nvarchar(50) NOT NULL,
		pbMovie_id int NOT NULL,
		pbDirector_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbMovieActor(
		pbMovieActor_id int NOT NULL IDENTITY(1000000000,1),
		movieID nvarchar(10) NOT NULL,
		aFirstName nvarchar(50) NOT NULL,
		aLastName nvarchar(50) NOT NULL,
		pbMovie_id int NOT NULL,
		pbActor_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);

CREATE TABLE PbMovieGenre(
		pbMovieGenre_id int NOT NULL IDENTITY(1000000000,1),
		movieID nvarchar(10) NOT NULL,
		genre nvarchar(20) NOT NULL,
		pbMovie_id int NOT NULL,
		pbGenre_id int NOT NULL,
		lastChangedBy nvarchar(10) NOT NULL,
		lastChangedOn datetime NOT NULL
);
 GO

---------------------------------
--Create Constraints
--Constraints must be created in order
--		based ont he table relationships
------------------------------------
--Primary Key Constraints
--Alternate Key Constraints
--Primary Key constraint
--Alternate Key constraint
--Foreign key constraint
--Check constraint

--PbUser Table Constraints
------------------------------------------
ALTER TABLE PbUser
	ADD CONSTRAINT PK_PbUser PRIMARY KEY CLUSTERED (pbUser_id);

ALTER TABLE PbUser
	ADD CONSTRAINT AK_PbUser UNIQUE(pbUserID);

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_userType
	CHECK (userType = 'A' OR userType = 'C' OR userType = 'AC');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_custType
	CHECK (custType = 'N' OR custType = 'P');

ALTER TABLE PbUser
	ADD CONSTRAINT CK_PbUser_banStatus
	CHECK (banStatus = 'Y' OR banStatus = 'N');

GO
--PbMovie Table Constraints
-------------------------------------------
ALTER TABLE PbMovie
	ADD CONSTRAINT PK_PbMovie PRIMARY KEY CLUSTERED (pbMovie_id);
	
ALTER TABLE PbMovie
	ADD CONSTRAINT AK_PbMovie UNIQUE(movieID);
GO
--PbGenre Table Constraints
--------------------------------------------
ALTER TABLE PbGenre
	ADD CONSTRAINT PK_PbGenre PRIMARY KEY CLUSTERED (pbGenre_id);
	
ALTER TABLE PbGenre
	ADD CONSTRAINT AK_PbGenre UNIQUE(genre);
GO
--PbActor Table Constraints
---------------------------------------------
ALTER TABLE PbActor
	ADD CONSTRAINT PK_PbActor PRIMARY KEY CLUSTERED (pbActor_id);
	
ALTER TABLE PbActor
	ADD CONSTRAINT AK_PbActor_aFirstName$aLastName UNIQUE(aFirstName,aLastName);

GO
--PbDirector Table Constraints
------------------------------------------------
ALTER TABLE PbDirector
	ADD CONSTRAINT PK_PbDirector PRIMARY KEY CLUSTERED (pbDirector_id);
	
ALTER TABLE PbDirector
	ADD CONSTRAINT AK_PbDirector_dFirstName$dLastName UNIQUE(dFirstName, dLastName);

GO
--PbQuestions Table Constraints
--------------------------------------------------
ALTER TABLE PbQuestion
	ADD CONSTRAINT PK_PbQuestion PRIMARY KEY CLUSTERED (pbQuestion_id);
	
ALTER TABLE PbQuestion
	ADD CONSTRAINT AK_PbQuestion_pbUserID$question UNIQUE(pbUserID, question);

ALTER TABLE PbQuestion
	ADD CONSTRAINT FK_PbQuestion_PbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);
GO
--PbPhone Table Constraints
----------------------------------------------------

ALTER TABLE PbPhone
	ADD CONSTRAINT PK_PbPhone PRIMARY KEY CLUSTERED (pbPhone_id);
	
ALTER TABLE PbPhone
	ADD CONSTRAINT AK_PbPhone_pbUserID$phoneNumber UNIQUE(pbUserID, phoneNumber);

ALTER TABLE PbPhone
	ADD CONSTRAINT FK_PbPhone_PbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

GO
--PbMovieItem Table Constraints
-----------------------------------------------------
ALTER TABLE PbMovieItem
	ADD CONSTRAINT PK_PbMovieItem PRIMARY KEY CLUSTERED (pbMovieItem_id);
	
ALTER TABLE PbMovieItem
	ADD CONSTRAINT AK_PbMovieItem UNIQUE(movieItemID);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT FK_PbMovieItem_PbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieItem
	ADD CONSTRAINT CK_PbMovieItem_copyFormat
	CHECK (copyFormat = 'DVD' OR copyFormat = 'BLU');
GO
--PbRequest Table Constraints
-----------------------------------------------------

ALTER TABLE PbRequest
	ADD CONSTRAINT PK_PbRequest PRIMARY KEY CLUSTERED (pbRequest_id);
	
ALTER TABLE PbRequest
	ADD CONSTRAINT AK_PbRequest_pbUserID$movieItemID$requestDate UNIQUE(pbUserID, movieItemID, requestDate);


ALTER TABLE PbRequest
	ADD CONSTRAINT FK_PbRequest_PbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbRequest
	ADD CONSTRAINT FK_PbRequest_PbMovieItem_id
	FOREIGN KEY (pbMovieItem_id) REFERENCES PbMovieItem(pbMovieItem_id);

GO
--PbRental Table Constraints
--------------------------------------------------------
ALTER TABLE PbRental
	ADD CONSTRAINT PK_PbRental PRIMARY KEY CLUSTERED (pbRental_id);
	
ALTER TABLE PbRental
	ADD CONSTRAINT AK_PbRental_pbUserID$movieItemID$rentalDate UNIQUE(pbUserID, movieItemID, rentalDate);

ALTER TABLE PbRental
	ADD CONSTRAINT FK_PbRental_PbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbRental
	ADD CONSTRAINT FK_PbRental_PbMovieItem_id
	FOREIGN KEY (pbMovieItem_id) REFERENCES PbMovieItem(pbMovieItem_id);

GO
--PbMovieDirector Table Constraints
--------------------------------------------------------
ALTER TABLE PbMovieDirector
	ADD CONSTRAINT PK_PbMovieDirector PRIMARY KEY CLUSTERED (pbMovieDirector_id);
	
ALTER TABLE PbMovieDirector
	ADD CONSTRAINT AK_PbMovieDirector_movieID$dFirstName$dLastName UNIQUE(movieID, dFirstName, dLastName);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_PbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_PbDirector_id
	FOREIGN KEY (pbDirector_id) REFERENCES PbDirector(pbDirector_id);
GO
--PbMovieActor Table Constraints
------------------------------------------------------
ALTER TABLE PbMovieActor
	ADD CONSTRAINT PK_PbMovieActor PRIMARY KEY CLUSTERED (pbMovieActor_id);
	
ALTER TABLE PbMovieActor
	ADD CONSTRAINT AK_PbMovieActor_movieID$aFirstName$aLastName UNIQUE(movieID, aFirstName, aLastName);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_PbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_PbActor_id
	FOREIGN KEY (pbActor_id) REFERENCES PbActor(pbActor_id);
GO
--PbMovieGenre Table Constraints
--------------------------------------------------------
ALTER TABLE PbMovieGenre
	ADD CONSTRAINT PK_PbMovieGenre PRIMARY KEY CLUSTERED (pbMovieGenre_id);
	
ALTER TABLE PbMovieGenre
	ADD CONSTRAINT AK_PbMovieGenre_movieID$genre UNIQUE(movieID, genre);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_PbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_PbGenre_id
	FOREIGN KEY (pbGenre_id) REFERENCES PbGenre(pbGenre_id);
GO