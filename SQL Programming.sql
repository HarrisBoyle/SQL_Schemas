--Create Tables
--Note that User has been renamed to User_table and Category to Category_table
--This is because these are special named variables (reserved words) and thus may cause issues later

--Create the user table
CREATE TABLE User_table(
    userId varchar(20) NOT NULL,
    name varchar(255) NOT NULL,
    emailAddress varchar(50) NOT NULL,
    CONSTRAINT pk_user_table PRIMARY KEY (userId)
);

--Create the Publisher table 
CREATE TABLE Publisher(
    publisherId varchar(4) NOT NULL,
    publisherName varchar(255),
    CONSTRAINT pk_Publisher PRIMARY KEY (publisherId)
);

--Create the Category table
CREATE TABLE Category_table(
    categoryCode varchar(3) NOT NULL,
    title varchar(255),
    CONSTRAINT pk_Category_table PRIMARY KEY (categoryCode)
);

--Create the Music table
CREATE TABLE Music(
    musicId varchar(4) NOT NULL,
    title varchar(255) NOT NULL,
    categoryCode varchar(3),
    publisherId varchar(4),
    costPerDownload float,
    CONSTRAINT pk_Music PRIMARY KEY (musicId),
    CONSTRAINT fk_Music_Category FOREIGN KEY (categoryCode) 
        REFERENCES Category_table (categoryCode),
    CONSTRAINT fk_Music_Publisher FOREIGN KEY (publisherId) 
        REFERENCES Publisher (publisherId)
);

--Create the MusicDownload table
CREATE TABLE MusicDownload(
    userId varchar(20),
    musicId varchar(4),
    downloadDate timestamp,
    CONSTRAINT fk_User_table FOREIGN KEY (userId) 
        REFERENCES User_table (userId),
    CONSTRAINT fk_Music FOREIGN KEY (musicId) 
        REFERENCES Music (musicId)    
);




--Insert Data into the newly created tables 

--Insert into the User table
INSERT INTO User_table 
	WITH users AS (
		SELECT 'kendj3','Kenderine, J','kendj3@hotmail.co.uk' FROM dual UNION ALL
		SELECT 'patel11','Patel, F','patel11@ntl.co.uk' FROM dual UNION ALL
		SELECT 'flak05','Flavel, K','flak05@freeserve.co.uk' FROM dual UNION ALL 
		SELECT 'johnsj9','Johnson, J','johnsj9@msn.co.uk' FROM dual UNION ALL
		SELECT 'keita77','Keita, R','keita77@hotmail.co.uk' FROM dual UNION ALL
		SELECT 'Simpb91','Simpson, B','Simpb91@tesco.co.uk' FROM dual
		)
SELECT * FROM users
;

--Insert into the Publisher table
INSERT INTO Publisher
	WITH publishers AS (
	SELECT 'P001','Arista Records' FROM dual UNION ALL
	SELECT 'P002','Lakeshore Records' FROM dual UNION ALL
	SELECT 'P003','EMI' FROM dual UNION ALL
	SELECT 'P004','DECCA' FROM dual UNION ALL
	SELECT 'P005','Sony Music' FROM dual UNION ALL
	SELECT 'P006','DJM Records' FROM dual
	)
SELECT * FROM publishers
;

--Insert into Category table
INSERT INTO Category_table
	WITH categories AS (
	SELECT 'C11', 'Classics' FROM dual UNION ALL
	SELECT 'C12', 'Pop-Rock' FROM dual UNION ALL
	SELECT 'C13', 'Movie Soundtrack' FROM dual
	)
SELECT * FROM categories
;

--Insert into Music table
INSERT INTO Music
	WITH music AS (
	SELECT 'M001', 'James Bond: Golden Eyes', 'C13', 'P001', 0.99 FROM dual UNION ALL
	SELECT 'M002', 'Lake House', 'C13', 'P002', 1.99 FROM dual UNION ALL
	SELECT 'M003', 'Dvorak: Symphony No 9', 'C11', 'P003', 1.49 FROM dual UNION ALL
	SELECT 'M004', 'Handel: Water Music', 'C11', 'P004', 1.79 FROM dual UNION ALL
	SELECT 'M005', 'Sense and Sensibility', 'C13', 'P005', 1.50 FROM dual UNION ALL
	SELECT 'M006', 'Beatles: Yesterday', 'C12', 'P005', 1.10 FROM dual UNION ALL
	SELECT 'M007', 'Elton John: Your Song', 'C12', 'P006', 0.89 FROM dual
	)
SELECT * FROM music
; 

--Insert into MusicDownload table 
INSERT INTO MusicDownload
	WITH downloads AS (
	SELECT 'kendj3', 'M002', '03-May-18' FROM dual UNION ALL
	SELECT 'johnsj9', 'M005', '01-May-19' FROM dual UNION ALL
	SELECT 'patel11', 'M002', '06-May-18' FROM dual UNION ALL
	SELECT 'johnsj9', 'M001', '06-May-19' FROM dual UNION ALL
	SELECT 'kendj3', 'M003', '01-Aug-19' FROM dual UNION ALL
	SELECT 'keita77', 'M004', '02-Aug-19' FROM dual UNION ALL
	SELECT 'Simpb91', 'M007', '05-Sep-18' FROM dual
	)
SELECT * FROM downloads
;
	 
	 
--2 - Write SQL Statements to return the following:	 
--(a) music id, title and publisher name of all music ordered by title

SELECT m.musicId, m.title, p.publisherName

FROM Music m

INNER JOIN Publisher p ON m.publisherId = p.publisherId

ORDER BY title

;

--(b) The name of the users who downloaded the 'Classics' category of music
--superfluous columns excluded to adhere exactly to brief but can be uncommented to show working

SELECT u.name --, c.title, md.userId, md.musicId

FROM  MusicDownload md
INNER JOIN User_table u ON u.userId = md.userId
INNER JOIN Music m ON m.musicId = md.musicId
INNER JOIN Category_table c ON c.categoryCode = m.categoryCode

WHERE c.title = 'Classics'

;

--(c) The number of music downloads for each category, showing the category titles 
--		and the number of downloads for each category

SELECT c.title, COUNT(*) AS NO_OF_DOWNLOADS

FROM  MusicDownload md
INNER JOIN User_table u ON u.userId = md.userId
INNER JOIN Music m ON m.musicId = md.musicId
INNER JOIN Category_table c ON c.categoryCode = m.categoryCode

GROUP BY c.title

;

--(d) The titles of the categories for which music was downloaded more than once

WITH download_count AS (
    SELECT c.title, COUNT(*) AS NO_OF_DOWNLOADS
    
    FROM  MusicDownload md
    INNER JOIN User_table u ON u.userId = md.userId
    INNER JOIN Music m ON m.musicId = md.musicId
    INNER JOIN Category_table c ON c.categoryCode = m.categoryCode
    
    GROUP BY c.title
    )
    
SELECT * FROM download_count 

WHERE NO_OF_DOWNLOADS > 1

;








