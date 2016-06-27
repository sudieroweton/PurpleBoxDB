--Sudie Roweton
--CS3550 Spring 2016
--Assignment 6
USE PurpleBox;
----------------------------
--One Admin User
----------------------------
INSERT INTO PbUser
(pbUserID, userFirstName, userLastName, userPassword, 
userType, custType, banStatus, lastChangedBy, lastChangedOn)
VALUES
('kf1234','Kim','Flynn','blueyed144','A','P','N','smr',GETDATE());

----------------------------
--One Customer User
----------------------------
INSERT INTO PbUser
(pbUserID, userFirstName, userLastName, userPassword, 
userType, custType, banStatus, lastChangedBy, lastChangedOn)
VALUES
('rr4417','Robert','Rodriguez','abcd1234','C','N','N','smr',GETDATE());

----------------------------------
--Two Phone Numbers for each user
----------------------------------
INSERT INTO PbPhone
(pbUserID, phoneNumber,pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('kf1234','801-544-1661',1000000000,'smr',GETDATE());

INSERT INTO PbPhone
(pbUserID, phoneNumber, pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('kf1234','801-828-0043',1000000000,'smr',GETDATE());

INSERT INTO PbPhone
(pbUserID, phoneNumber,pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('rr4417','801-241-5508',1000000001,'smr',GETDATE());

INSERT INTO PbPhone
(pbUserID, phoneNumber, pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('rr4417','970-901-2133',1000000001,'smr',GETDATE());

---------------------------------------
--Two Security Questions for each user
---------------------------------------

INSERT INTO PbQuestion
(pbUserID, question, answer, pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('kf1234','What is your Mothers Maiden name?','Lyons', 1000000000, 'smr', GETDATE());

INSERT INTO PbQuestion
(pbUserID, question, answer, pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('kf1234','Where were you on January 1, 2000?','New York City', 1000000000, 'smr', GETDATE());

INSERT INTO PbQuestion
(pbUserID, question, answer, pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('rr4417','What is the name of your favorite pet?','Rosie', 1000000001, 'smr', GETDATE());

INSERT INTO PbQuestion
(pbUserID, question, answer, pbUser_id, lastChangedBy, lastChangedOn)
VALUES
('rr4417','What street did you grow up on?','Darla Drive', 1000000001, 'smr', GETDATE());


----------------------------------------
--Three Movies
----------------------------------------
INSERT INTO PbMovie
(movieID, movieTitle, movieKeywords, lastChangedBy, lastChangedOn)
VALUES
('mth114', 'The Heat','fbi agent, car chase, tough cop, female cop, police shootout, boston','smr',GETDATE());

INSERT INTO PbMovie
(movieID, movieTitle, movieKeywords, lastChangedBy, lastChangedOn)
VALUES
('mgg987', 'Gone Girl','disappearance, missing wife, murder suspect, psychopath, based on novel, revenge, surprise ending','smr',GETDATE());

INSERT INTO PbMovie
(movieID, movieTitle, movieKeywords, lastChangedBy, lastChangedOn)
VALUES
('mbs613', 'Black Swan','ballerina, ballet, female protagonist, swan lake, disturbed, new york city, obsession, mental illness','smr',GETDATE());

----------------------------------------
--Three Genres
----------------------------------------
INSERT INTO PbGenre
(genre, lastChangedBy, lastChangedOn)
VALUES
('crime', 'smr', GETDATE());


INSERT INTO PbGenre
(genre, lastChangedBy, lastChangedOn)
VALUES
('comedy', 'smr', GETDATE());


INSERT INTO PbGenre
(genre, lastChangedBy, lastChangedOn)
VALUES
('drama', 'smr', GETDATE());

INSERT INTO PbMovieGenre
(movieID, genre, pbMovie_id, pbGenre_id, lastChangedBy, lastChangedOn)
VALUES
('mth114','comedy',1000000000,1000000001,'smr',GETDATE());

INSERT INTO PbMovieGenre
(movieID, genre, pbMovie_id, pbGenre_id, lastChangedBy, lastChangedOn)
VALUES
('mgg987','crime',1000000001,1000000000,'smr',GETDATE());

INSERT INTO PbMovieGenre
(movieID, genre, pbMovie_id, pbGenre_id, lastChangedBy, lastChangedOn)
VALUES
('mbs613','drama',1000000002,1000000002,'smr',GETDATE());

----------------------------------------
--Six Actors (2 from each movie)
----------------------------------------
INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Sandra','Bullock','smr',GETDATE());

INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Melissa','McCarthy','smr',GETDATE());

INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Ben','Affleck','smr',GETDATE());

INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Rosamund','Pike','smr',GETDATE());

INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Natalie','Portman','smr',GETDATE());

INSERT INTO PbActor
(aFirstName, aLastName, lastChangedBy, lastChangedOn)
VALUES
('Vincent','Cassel','smr',GETDATE());

INSERT INTO PbMovieActor
(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
VALUES
('mth114','Sandra','Bullock',1000000000, 1000000000, 'smr', GETDATE());

INSERT INTO PbMovieActor
(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
VALUES
('mth114','Melissa','McCarthy',1000000000, 1000000001, 'smr', GETDATE());

INSERT INTO PbMovieActor
(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
VALUES
('mgg987','Ben','Affleck',1000000001, 1000000002, 'smr', GETDATE());

INSERT INTO PbMovieActor
(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
VALUES
('mgg987','Rosamund','Pike',1000000001, 1000000003, 'smr', GETDATE());

INSERT INTO PbMovieActor
(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
VALUES
('mbs613','Natalie','Portman',1000000002, 1000000004, 'smr', GETDATE());

INSERT INTO PbMovieActor
(movieID, aFirstName, aLastName, pbMovie_id, pbActor_id, lastChangedBy, lastChangedOn)
VALUES
('mbs613','Vincent','Cassel',1000000002, 1000000005, 'smr', GETDATE());

----------------------------------------
--Three Directors (1 from each movie)
----------------------------------------
INSERT INTO PbDirector
(dFirstName, dLastName, lastChangedBy, lastChangedOn)
VALUES
('Paul','Feig','smr',GETDATE());

INSERT INTO PbDirector
(dFirstName, dLastName, lastChangedBy, lastChangedOn)
VALUES
('David','Fincher','smr',GETDATE());

INSERT INTO PbDirector
(dFirstName, dLastName, lastChangedBy, lastChangedOn)
VALUES
('Darren','Aronofsky','smr',GETDATE());

INSERT INTO PbMovieDirector
(movieID, dFirstName, dLastName, pbMovie_id, pbDirector_id, lastChangedBy, lastChangedOn)
VALUES
('mth114','Paul','Feig', 1000000000, 1000000000,'smr',GETDATE());

INSERT INTO PbMovieDirector
(movieID, dFirstName, dLastName, pbMovie_id, pbDirector_id, lastChangedBy, lastChangedOn)
VALUES
('mgg987','David','Fincher', 1000000001, 1000000001,'smr',GETDATE());

INSERT INTO PbMovieDirector
(movieID, dFirstName, dLastName, pbMovie_id, pbDirector_id, lastChangedBy, lastChangedOn)
VALUES
('mbs613','Darren','Aronofsky', 1000000002, 1000000002,'smr',GETDATE());

----------------------------------------
--Two MovieItems for Each Movie
----------------------------------------
INSERT INTO PbMovieItem
(movieItemID, movieID, copyNum,copyFormat, pbMovie_id,lastChangedBy,lastChangedOn)
VALUES('mith1','mth114', 1, 'DVD',1000000000,'smr',GETDATE());

INSERT INTO PbMovieItem
(movieItemID, movieID, copyNum,copyFormat, pbMovie_id,lastChangedBy,lastChangedOn)
VALUES('mith2','mth114', 2, 'BLU',1000000000,'smr',GETDATE());

INSERT INTO PbMovieItem
(movieItemID, movieID, copyNum,copyFormat, pbMovie_id,lastChangedBy,lastChangedOn)
VALUES('migg1','mgg987', 1, 'DVD',1000000001,'smr',GETDATE());

INSERT INTO PbMovieItem
(movieItemID, movieID, copyNum,copyFormat, pbMovie_id,lastChangedBy,lastChangedOn)
VALUES('migg2','mgg987', 2, 'BLU',1000000001,'smr',GETDATE());

INSERT INTO PbMovieItem
(movieItemID, movieID, copyNum,copyFormat, pbMovie_id,lastChangedBy,lastChangedOn)
VALUES('mibs1','mbs613', 1, 'DVD',1000000002,'smr',GETDATE());

INSERT INTO PbMovieItem
(movieItemID, movieID, copyNum,copyFormat, pbMovie_id,lastChangedBy,lastChangedOn)
VALUES('mibs2','mbs613', 2, 'BLU',1000000002,'smr',GETDATE());
