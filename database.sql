--DROP DATABASE project;
CREATE DATABASE project;
GO
USE project;
--Basic Structure of the Database

GO

CREATE PROCEDURE createAllTables
AS
CREATE TABLE Users(
username varchar(20) primary key,
password varchar(20)
);
CREATE TABLE System_admin(
username varchar(20) UNIQUE,
A_ID int primary key identity,
CONSTRAINT adminuser foreign key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE
)
CREATE TABLE Fans(
username varchar(20) UNIQUE,
national_id varchar(20) primary key,
Name varchar(20),
Birthdates datetime,
address varchar(20),
phone_number int,
status BIT DEFAULT 1,
CONSTRAINT fanuser foreign key(username) references Users  ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Stadiums(
S_ID int primary key identity,
Name varchar(20) UNIQUE,
Capacity int,
Location varchar(20),
Status BIT DEFAULT 1,
)

CREATE TABLE Managers(
username varchar(20) UNIQUE,
M_ID int primary key identity,
name varchar(20),
S_ID int,
CONSTRAINT Manageruser foreign key(username) references Users  ON DELETE CASCADE ON UPDATE CASCADE ,
CONSTRAINT stad foreign key(S_ID) references Stadiums  ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Association_Manager(
username varchar(20) UNIQUE,
ID int primary key identity,
name varchar(20)
CONSTRAINT AManageruser foreign key(username) references Users ,
)

CREATE TABLE Clubs(
C_ID int primary key identity,
name varchar(20) UNIQUE,
location varchar(20)
)

CREATE TABLE Representative(
username varchar(20) UNIQUE,
R_ID int primary key identity,
C_ID int,
name varchar(20),
CONSTRAINT repuser foreign key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE ,
CONSTRAINT repclub foreign key(C_ID) references Clubs ON DELETE CASCADE ON UPDATE CASCADE,

)
CREATE TABLE Matches(
G_ID int primary key identity,
starting_time datetime,
ending_time datetime,
allowed_number_of_attendees int,
S_ID int,
Host int NOT NULL,
Guest int NOT NULL,
CONSTRAINT Hostof foreign key(Host) REFERENCES Clubs ON DELETE CASCADE ON UPDATE CASCADE,                
CONSTRAINT Guestof foreign key(Guest) REFERENCES Clubs  ON DELETE NO ACTION ON UPDATE NO ACTION,               
CONSTRAINT stadiumheldon foreign key(S_ID) REFERENCES Stadiums ON DELETE CASCADE ON UPDATE CASCADE ,
)
--drop table matches

CREATE TABLE request(
G_ID int ,
R_ID int,
M_ID int,
response varchar(20) DEFAULT 'unhandled'
CONSTRAINT managerof foreign key(M_ID) REFERENCES Managers ON DELETE NO ACTION ON UPDATE NO ACTION ,
CONSTRAINT matchreq foreign key(G_ID) REFERENCES Matches  ON DELETE CASCADE ON UPDATE CASCADE,           
CONSTRAINT rep foreign key(R_ID) REFERENCES  Representative ON DELETE NO ACTION ON UPDATE NO ACTION ,
CONSTRAINT primarykeys primary key(M_ID,G_ID)
)
--drop table request

CREATE TABLE Tickets(
G_ID int ,
T_ID int identity,
S_ID int NOT NULL,
status BIT DEFAULT 1,
national_ID varchar(20),
CONSTRAINT ticketsof foreign key(G_ID) REFERENCES Matches ON DELETE CASCADE ON UPDATE CASCADE ,
CONSTRAINT stadiumof foreign key(S_ID) references stadiums ON DELETE NO ACTION ON UPDATE NO ACTION , 
CONSTRAINT fanof foreign key(national_ID) references fans ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT primaries primary key(G_ID,T_ID)
)
--drop table tickets

GO
--drop procedure createAllTables
EXEC createAllTables
INSERT INTO users 
VALUES ('admin', 'admin');
INSERT INTO System_admin
VALUES ('admin');
GO


CREATE PROCEDURE clearAllTables 
AS
ALTER TABLE tickets
DROP CONSTRAINT ticketsof,
     CONSTRAINT stadiumof,
     CONSTRAINT fanof

ALTER TABLE request
DROP CONSTRAINT managerof,
     CONSTRAINT matchreq,
     CONSTRAINT rep

ALTER TABLE Matches
DROP CONSTRAINT Guestof,
     CONSTRAINT Hostof,
     CONSTRAINT stadiumheldon

ALTER TABLE representative
DROP CONSTRAINT repuser,
     CONSTRAINT repclub

ALTER TABLE association_manager
DROP CONSTRAINT AManageruser

ALTER TABLE managers
DROP CONSTRAINT Manageruser,
     CONSTRAINT stad

ALTER TABLE fans
DROP CONSTRAINT fanuser

ALTER TABLE system_admin
DROP CONSTRAINT adminuser
 
TRUNCATE TABLE Tickets
TRUNCATE TABLE request
TRUNCATE TABLE Matches
TRUNCATE TABLE Representative
TRUNCATE TABLE clubs
TRUNCATE TABLE Association_Manager
TRUNCATE TABLE Managers
TRUNCATE TABLE Stadiums
TRUNCATE TABLE Fans
TRUNCATE TABLE System_admin
TRUNCATE TABLE Users


ALTER TABLE system_admin
ADD CONSTRAINT adminuser foreign key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE fans
ADD CONSTRAINT fanuser foreign key(username) references Users  ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE managers
ADD CONSTRAINT Manageruser foreign key(username) references Users  ON DELETE CASCADE ON UPDATE CASCADE ,
     CONSTRAINT stad foreign key(S_ID) references Stadiums  ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE representative
ADD CONSTRAINT repuser foreign key(username) references Users ON DELETE CASCADE ON UPDATE CASCADE ,
    CONSTRAINT repclub foreign key(C_ID) references Clubs ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE association_Manager
ADD CONSTRAINT AManageruser foreign key(username) references Users

ALTER TABLE Matches
ADD CONSTRAINT Hostof  foreign key(Host) REFERENCES Clubs  ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Guestof  foreign key(Guest) REFERENCES Clubs  ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT stadiumheldon foreign key(S_ID) REFERENCES Stadiums ON DELETE NO ACTION ON UPDATE NO ACTION 

ALTER TABLE request
ADD CONSTRAINT managerof foreign key(M_ID) REFERENCES Managers ON DELETE NO ACTION ON UPDATE NO ACTION ,
    CONSTRAINT matchreq foreign key(G_ID) REFERENCES Matches  ON DELETE CASCADE ON UPDATE CASCADE,           
    CONSTRAINT rep foreign key(R_ID) REFERENCES  Representative ON DELETE NO ACTION ON UPDATE NO ACTION

ALTER TABLE Tickets
ADD CONSTRAINT ticketsof foreign key(G_ID) REFERENCES Matches ON DELETE CASCADE ON UPDATE CASCADE ,
    CONSTRAINT stadiumof foreign key(S_ID) references stadiums ON DELETE NO ACTION ON UPDATE NO ACTION , 
    CONSTRAINT fanof foreign key(national_ID) references fans ON DELETE CASCADE ON UPDATE CASCADE

--EXEC clearAllTables;


GO

CREATE PROCEDURE dropAllTables 
AS
DROP TABLE Tickets
DROP TABLE request
DROP TABLE Matches
DROP TABLE Representative
DROP TABLE clubs
DROP TABLE Association_Manager
DROP TABLE Managers
DROP TABLE Stadiums
DROP TABLE Fans
DROP TABLE System_admin
DROP TABLE Users
GO
--drop procedure dropAllTables
--exec dropAllTables

-- triggers
GO

CREATE TRIGGER deleterequestsOnManagerDelete
    ON managers
    FOR DELETE
AS
    DELETE FROM request
    WHERE M_ID IN   (SELECT M_ID
                        FROM deleted)
GO
--drop trigger deleterequestsOnManagerDelete;

CREATE TRIGGER deleteMatchesOnClubDelete
    ON clubs 
    FOR DELETE
AS
    DELETE FROM matches
    WHERE Guest IN   (SELECT C_ID
                        FROM deleted)

GO
--drop trigger deleteMatchesOnClubDelete;

CREATE TRIGGER trigRepresentative
    ON representative
    FOR DELETE
AS
    DELETE FROM users
    WHERE username NOT IN  (SELECT username FROM representative
                            UNION
                            SELECT username FROM association_manager
                            UNION
                            SELECT username FROM managers
                            UNION
                            SELECT username FROM fans
                            UNION
                            SELECT username FROM system_admin)

GO

CREATE TRIGGER trigAssociationManager
    ON association_manager
    FOR DELETE
AS
    DELETE  FROM users
    WHERE username NOT IN  (SELECT username FROM representative
                            UNION
                            SELECT username FROM association_manager
                            UNION
                            SELECT username FROM managers
                            UNION
                            SELECT username FROM fans
                            UNION
                            SELECT username FROM system_admin)

GO

CREATE TRIGGER trigManagers
    ON managers
    FOR DELETE
AS
    DELETE FROM users
    WHERE username NOT IN  (SELECT username FROM representative
                            UNION
                            SELECT username FROM association_manager
                            UNION
                            SELECT username FROM managers
                            UNION
                            SELECT username FROM fans
                            UNION
                            SELECT username FROM system_admin)

GO

CREATE TRIGGER trigFans
    ON fans
    FOR DELETE
AS
    DELETE FROM users
    WHERE username NOT IN  (SELECT username FROM representative
                            UNION
                            SELECT username FROM association_manager
                            UNION
                            SELECT username FROM managers
                            UNION
                            SELECT username FROM fans
                            UNION
                            SELECT username FROM system_admin)

GO

CREATE TRIGGER trigSystemAdmin
    ON system_admin
    FOR DELETE
AS
    DELETE FROM users
    WHERE username NOT IN  (SELECT username FROM representative
                            UNION
                            SELECT username FROM association_manager
                            UNION
                            SELECT username FROM managers
                            UNION
                            SELECT username FROM fans
                            UNION
                            SELECT username FROM system_admin)

GO

--Basic Data Retrieval
--a
CREATE VIEW allAssocManagers AS
SELECT A.username, U.password, A.name
FROM Association_Manager A inner join Users U on A.username = U.username
GO

--b
CREATE VIEW allClubRepresentatives AS
SELECT R.username,U.password, R.name , C.name AS club_name
FROM Representative R inner join Clubs  C on R.C_ID = C.C_ID
inner join Users U on R.username = U.username
GO

--c
CREATE VIEW allStadiumManagers AS
SELECT M.username,U.password, M.name, S.name AS stadium_name
FROM Managers M inner join Stadiums S on M.S_ID = S.S_ID
inner join Users U on M.username = U.username
GO

--d
CREATE VIEW allFans AS
SELECT U.username, U.password, F.Name, F.national_ID, F.Birthdates, F.status
FROM Fans F inner join Users U on F.username = U.username
GO

--e
CREATE VIEW allMatches AS 
SELECT C1.name as Host_club, C2.name as Guest_club,
M.starting_time
FROM Matches M inner join Clubs C1 on M.host = C1.C_ID
inner join Clubs C2 on M.guest = C2.C_ID 
GO

--f
CREATE VIEW allTickets AS
SELECT C1.name AS Host_club, C2.name AS Guest_club, S.name AS stadium_name, M.starting_time
FROM Tickets T inner join Matches M on T.G_ID = M.G_ID 
inner join Stadiums S on T.S_ID = S.S_ID
inner join Clubs C1 on M.host = C1.C_ID 
inner join Clubs C2 on M.guest = C2.C_ID
GO

--g
CREATE VIEW allCLubs AS
SELECT name, location
FROM Clubs
GO

--h
CREATE VIEW allStadiums AS
SELECT name, location, capacity, status    
FROM Stadiums
GO

--i
CREATE VIEW allRequests AS 
SELECT R1.username AS representative_username , M.username AS manager_username, R2.response AS status
FROM request R2 inner join Representative R1 on R1.R_ID = R2.R_ID 
inner join Managers M on R2.M_ID = M.M_ID 
GO


--Stored Procedures and Functions

--I
CREATE PROCEDURE addAssociationManager
@name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20)
AS
INSERT INTO Users VALUES(@username,@password);
INSERT INTO Association_Manager VALUES(@username,@name)
GO

--II
CREATE PROCEDURE addNewMatch
@HostClub VARCHAR(20),
@GuestClub VARCHAR(20),
@startTime datetime,
@EndTime datetime
AS
declare @Club1 AS int;
set @Club1 = (SELECT C_ID 
FROM Clubs C
WHERE C.Name = @HostClub);
declare @Club2 AS int;
set @Club2 = (SELECT C_ID 
FROM Clubs C
WHERE C.Name = @GuestClub);
INSERT INTO Matches VALUES(@startTime,@EndTime,NULL,NULL,@Club1,@Club2)
GO

--III
CREATE VIEW clubsWithNoMatches AS
SELECT Name
From Clubs
EXCEPT 
SELECT Guest_club
FROM allMatches
EXCEPT
SELECT Host_club
FROM allMatches
GO

--IV
CREATE PROCEDURE deleteMatch
@HostClub VARCHAR(20),
@GuestClub VARCHAR(20)
AS
declare @Club1 AS int;
set @Club1 = (SELECT C_ID 
FROM Clubs C1
WHERE C1.Name = @HostClub);
declare @Club2 AS int;
set @Club2 = (SELECT C_ID 
FROM Clubs C2
WHERE C2.Name = @GuestClub);
DELETE FROM Matches 
WHERE Host = @Club1 AND Guest = @Club2;
GO

--V
CREATE PROCEDURE deleteMatchesOnStadium
@StadiumName VARCHAR(20)
AS
declare @stadID AS int;
set @stadID = (SELECT S_ID 
FROM Stadiums
WHERE Name = @StadiumName);
DELETE FROM Matches 
WHERE S_ID = @stadID AND starting_time > CURRENT_TIMESTAMP
GO

--VI
CREATE PROCEDURE addClub
@Clubname VARCHAR(20),
@location VARCHAR(20)
AS 
INSERT INTO Clubs
VALUES (@Clubname, @location);
GO


--VII
CREATE PROCEDURE addTicket
@HostClubName VARCHAR(20),
@GuestClubName VARCHAR(20),
@startTime datetime
AS
DECLARE @hostingClubID int
SET @hostingClubID =  (SELECT c_id
                FROM clubs 
                WHERE name = @HostClubName)

DECLARE @competingClubID int
SET @competingClubID =  (SELECT c_id
                FROM clubs 
                WHERE name = @GuestClubName)

DECLARE @matchID int
SET @matchID = (SELECT g_id
                FROM matches
                WHERE host = @hostingClubID AND guest = @competingClubID AND starting_time = @startTime)

DECLARE @stadiumID int
SET @stadiumID = (  SELECT s_id 
                    FROM Matches
                    WHERE g_ID = @matchID)

INSERT INTO Tickets 
VALUES (@matchID, @stadiumID,1,NULL);
GO

--VIII
CREATE PROCEDURE deleteClub
@clubName VARCHAR(20)
AS
ALTER TABLE Matches
DROP CONSTRAINT Guestof;
DELETE FROM clubs
WHERE name = @clubName
ALTER TABLE Matches
ADD CONSTRAINT Guestof  foreign key(Guest) REFERENCES Clubs  ON DELETE NO ACTION ON UPDATE NO ACTION
GO
--select * from matches
--DROP PROCEDURE deleteClub;

--IX
CREATE PROCEDURE addStadium
@stadiumName VARCHAR(20),
@location VARCHAR(20),
@capacity INT
AS
INSERT INTO stadiums (name, capacity, location)
VALUES (@stadiumName,@capacity,@location)
GO

--X
CREATE PROCEDURE deleteStadium
@stadiumName VARCHAR(20)
AS
ALTER TABLE request
DROP CONSTRAINT managerof

DELETE FROM stadiums
WHERE name = @stadiumName

ALTER TABLE request
ADD CONSTRAINT managerof foreign key(M_ID) REFERENCES Managers ON DELETE NO ACTION ON UPDATE NO ACTION
GO
--drop procedure deleteStadium

--XI
CREATE PROCEDURE blockFan
@nationalID varchar(20)
AS
UPDATE Fans
SET status = 0
WHERE Fans.national_ID = @nationalID
GO

--XII
CREATE PROCEDURE unblockFan
@nationalID varchar(20)
AS
UPDATE Fans
SET status = 1
WHERE Fans.national_ID = @nationalID
GO

--XIII
CREATE PROCEDURE addRepresentative 
@name varchar(20),
@Clubname varchar(20),
@username varchar(20),
@password varchar(20)
AS 
declare @club_id AS INT 
SET @club_id = (
SELECT C_ID 
FROM Clubs
WHERE name = @Clubname
)
insert into Users values (@username,@password);
insert into Representative values(@username,@club_id,@name)

GO

--XIV 
CREATE FUNCTION [viewAvailableStadiumsOn] 
(@Dates datetime)
RETURNS @stadium Table (name VARCHAR(20),
Location VARCHAR(20),
capacity INT)
AS
BEGIN
INSERT INTO @stadium
SELECT S.Name,S.Location,S.Capacity
FROM Stadiums S 
WHERE S.Status = 1
EXCEPT
SELECT S1.Name, S1.Location, S1.Capacity
FROM Stadiums S1 INNER JOIN Matches M ON M.S_ID = S1.S_ID AND M.starting_time <= @Dates and M.ending_time >= @Dates
RETURN
END
GO

--XV
CREATE PROCEDURE addHostRequest
@clubName varchar(20),
@stadiumName varchar(20),
@starttime datetime
AS
DECLARE @S_ID AS INT 
SET @S_ID = (
SELECT S_ID 
FROM Stadiums 
WHERE name = @stadiumName
)
DECLARE @C_ID AS INT 
SET @C_ID = (
SELECT C_ID
FROM Clubs
WHERE name = @clubName
)
DECLARE @R_ID AS INT 
SET @R_ID = (
SELECT R_ID 
FROM Representative 
WHERE C_ID = @C_ID
)
DECLARE @G_ID AS INT 
SET @G_ID = (
SELECT G_ID
FROM Matches
WHERE starting_time = @starttime
)
DECLARE @M_ID AS INT
SET @M_ID = (
SELECT M_ID 
FROM Managers 
WHERE S_ID = @S_ID
)

insert into request (G_ID, R_ID, M_ID) values(@G_ID,@R_ID,@M_ID)
GO


--XVI
CREATE function [allUnassignedMatches] (@clubname varchar(20))

RETURNS @table Table(
GuestClub varchar(20),starttime datetime)

AS 
BEGIN 
DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @clubname
)
INSERT INTO @table
SELECT c.name ,m.starting_time
FROM Matches m inner join Clubs c On c.C_ID = m.Guest
WHERE m.Host=@Hid and m.S_ID is null
return
end
GO

--XVII
CREATE PROCEDURE addStadiumManager
@name varchar(20)
,@stadium_name varchar(20)
,@user_name varchar(20)
,@password varchar(20)

AS
DECLARE @stadium_id AS INT
set @stadium_id=(
SELECT s.S_ID
FROM Stadiums s
WHERE s.Name=@stadium_name
)

INSERT INTO Users VALUES (@user_name,@password)
INSERT INTO Managers VALUES (@user_name,@name,@stadium_id)
GO


--XVIII
create function [allPendingRequests](@username varchar(20))
RETURNS @table Table(
club_rep varchar(20),guest varchar(20),starttime datetime)

AS
BEGIN
DECLARE @man_id AS INT
SET @man_id = (
SELECT M_ID
FROM Managers 
WHERE username = @username)
INSERT INTO @table
SELECT r2.name , clubs.name,Matches.starting_time
FROM request r inner join Representative r2 on r.R_ID=r2.R_ID inner join Matches on r.G_ID=Matches.G_ID inner join Clubs on clubs.C_ID= Matches.Guest
WHERE r.response='unhandled' and r.M_ID=@man_id
return 
end
GO


--XIX
CREATE PROCEDURE acceptRequest
@username varchar(20),
@HostClub varchar(20),
@GuestClub varchar(20),
@datetime datetime
AS 

DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostClub
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestClub
)
DECLARE @match_id as INT
set @match_id=(
select m.G_ID
from Matches m
WHERE m.Host= @Hid AND m.Guest = @Cid AND m.starting_time=@datetime
)
DECLARE @mang_id as int
set @mang_id=(
select m.M_ID
FROM Managers m
WHERE m.username=@username
)
DECLARE @stadium_id as int
set @stadium_id =(
SELECT S_ID
FROM Managers
WHERE M_ID = @mang_id)

DECLARE @CAP as int 
SET @CAP =(
SELECT Capacity
FROM Stadiums
WHERE S_ID = @stadium_id)

If EXISTS (SELECT * 
           FROM request
           WHERE @match_id=G_ID and @mang_id=M_ID and response = 'unhandled')
BEGIN 
    UPDATE request
    SET response='accepted'
    WHERE @match_id=request.G_ID and @mang_id=M_ID
    UPDATE Matches
    SET S_ID = @stadium_id , allowed_number_of_attendees = @CAP
    WHERE G_ID = @match_id AND S_ID is NULL
    
    DECLARE @i int = 0
    WHILE @i < @CAP
    BEGIN
        SET @i = @i + 1
        EXEC addTicket @hostClubName =  @HostClub, @guestClubName = @GuestClub ,@startTime = @datetime;
    END
    

END
GO
--drop procedure acceptRequest;


--XX
CREATE PROCEDURE rejectRequest
@username varchar(20),
@HostName varchar(20),
@GuestName varchar(20),
@datetime datetime
AS 

DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostName
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestName
)
DECLARE @match_id as INT
set @match_id=(
select m.G_ID
from Matches m
WHERE m.Host= @Hid AND m.Guest = @Cid AND m.starting_time=@datetime
)
DECLARE @mang_id as int
set @mang_id=(
select m.M_ID
FROM Managers m
WHERE m.username=@username
)

UPDATE request
SET response='rejected'
WHERE @match_id=request.G_ID and @mang_id=M_ID and response = 'unhandled'
GO
--drop procedure rejectRequest

--XXI
CREATE PROCEDURE addFan
@name varchar(20),
@username varchar(20),
@password varchar(20),
@nationalid varchar(20),
@birthdate datetime,
@address varchar(20),
@phone int
AS
INSERT INTO Users values(@username,@password);
INSERT INTO Fans (username,national_id,Name, Birthdates, address, phone_number) Values(@username,@nationalid,@name,@birthdate,@address,@phone);
GO

--XXII
CREATE FUNCTION [upcomingMatchesOfClub]

(@club VARCHAR(20))
RETURNS @Match TABLE (
givenClub VARCHAR(20),
competingClub VARCHAR(20),
Starttime DATETIME,
Stadium_hosting VARCHAR(20))

AS 
BEGIN
declare @Club1 AS int;
set @Club1 = (SELECT C_ID 
FROM Clubs C
WHERE C.Name = @club);

INSERT INTO @Match
SELECT C2.name, C1.name,M.starting_time,S.Name
FROM Matches M INNER JOIN Clubs C1 ON M.Guest = C1.C_ID 
INNER JOIN Clubs C2 ON M.HOST = C2.C_ID INNER JOIN Stadiums S ON M.S_ID = S.S_ID 
WHERE M.Host = @Club1 AND M.starting_time > CURRENT_TIMESTAMP;

INSERT INTO @Match
SELECT C1.name, C2.name,M.starting_time,S.Name
FROM Matches M INNER JOIN Clubs C1 ON M.Guest = C1.C_ID 
INNER JOIN Clubs C2 ON M.HOST = C2.C_ID INNER JOIN Stadiums S ON M.S_ID = S.S_ID
WHERE M.Guest = @Club1 AND M.starting_time > CURRENT_TIMESTAMP;
RETURN 
END
GO

--XXIII
create function [availableMatchesToAttend](@time date)

RETURNS @table Table(host_club varchar(20),guest_club varchar(20),starttime datetime,stadium_name varchar(20))
AS
BEGIN
INSERT INTO @table
SELECT DISTINCT h.name,c.name,m.starting_time,s.Name
FROM Matches m inner join Clubs h on m.Host=h.C_ID inner join Clubs c on m.Guest=c.C_ID inner join Stadiums s on m.S_ID=s.S_ID inner join Tickets t on s.S_ID=t.S_ID and t.G_ID=m.G_ID
where m.starting_time >= @time and EXISTS(
select t1.T_ID
from Tickets t1
where t1.status=1 and t.T_ID=t1.T_ID
)
return
end
GO

--XXI
CREATE PROCEDURE purchaseTicket
@nationalID VARCHAR(20),
@HostClub varchar(20),
@GuestClub varchar(20),
@date datetime
AS
DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostClub
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestClub
)
DECLARE @Mid AS INT
SET @Mid = (
SELECT G_ID 
FROM Matches 
WHERE starting_time = @date AND (Host = @Hid AND Guest = @Cid) AND starting_time >= CURRENT_TIMESTAMP
)
DECLARE @Tid AS INT 
SET @Tid = (
SELECT TOP 1 T_ID
FROM Tickets 
WHERE G_ID = @Mid and status = 1
)
UPDATE Tickets
set status = 0, national_ID = @nationalID
where T_ID = @Tid AND G_ID = @Mid
GO

--XXV
CREATE PROCEDURE updateMatchHost
@HostClub varchar(20),
@GuestClub varchar(20),
@starttime datetime
AS
DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostClub
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestClub
)
UPDATE Matches
SET Host = @Cid, Guest = @Hid
where starting_time = @starttime
GO


--XXVI
CREATE VIEW matchesPerTeam AS
SELECT c.name AS club_name, COUNT(*) AS numberOfMatches
FROM Clubs c INNER JOIN Matches M ON M.Host = c.C_ID OR M.Guest = c.C_ID
WHERE M.starting_time < CURRENT_TIMESTAMP
Group by c.name
GO

--XXVII
CREATE VIEW clubsNeverMatched AS
SELECT C1.name AS 'firstclub', C2.name AS 'secondclub'
FROM Clubs C1 ,Clubs C2
WHERE C1.C_ID <> C2.C_ID AND C1.C_ID < C2.C_ID AND
NOT EXISTS(SELECT Host, Guest
		   FROM Matches M
		   WHERE (C1.C_ID = M.Host OR C1.C_ID = M.Guest) 
		   AND (C2.C_ID = M.Host OR C2.C_ID = M.Guest) AND (M.starting_time < CURRENT_TIMESTAMP))
GO



--XXVIII
CREATE FUNCTION [clubsNeverPlayed]
(@Club VARCHAR(20))
RETURNS @neverplayedclubs Table (
club_names VARCHAR(20))
AS
BEGIN
insert into @neverplayedclubs
SELECT c.secondclub
FROM clubsNeverMatched c
WHERE c.firstclub = @Club

insert into @neverplayedclubs
SELECT c.firstclub
FROM clubsNeverMatched c
WHERE c.secondclub = @Club

RETURN 
END
GO

--XXIX
CREATE FUNCTION [matchWithHighestAttendance]
()
RETURNS @t TABLE (
hosting_club_name VARCHAR(20),
competing_club_name VARCHAR(20)
)
AS
BEGIN
		INSERT INTO @t
		SELECT H.name, C.name
		FROM matches G
		INNER JOIN clubs H
		ON G.host = H.c_id
		INNER JOIN clubs C
		ON G.guest = C.c_id
		INNER JOIN tickets T
		ON T.g_id = G.g_id
		GROUP BY G.host, G.guest, H.name, C.name
		HAVING  COUNT(*) = (	SELECT MAX(X)
							FROM (
								SELECT COUNT(*) AS X
								FROM matches Gx
								INNER JOIN tickets Tx
								ON Gx.g_id = Tx.g_id 
								GROUP BY Gx.host, Gx.guest
								) AS T
							)
		
		RETURN
END
GO


---XXX
CREATE FUNCTION [matchesRankedByAttendance] 
()
RETURNS @t TABLE (
    rank int,
    hosting_club_name VARCHAR(20),
    competing_club_name VARCHAR(20)
)

BEGIN
    INSERT INTO @t
    SELECT  RANK()OVER(ORDER BY COUNT(*) DESC) AS s_rank, H.name AS host, C.name AS guest 
    FROM matches G
    INNER JOIN clubs H
    ON G.host = H.c_id
    INNER JOIN clubs C
    ON G.guest = C.c_id
    INNER JOIN tickets T
    ON T.g_id = G.g_id
    GROUP BY G.G_ID, H.name, C.name
   
    RETURN
END
GO

--XXXI
CREATE FUNCTION [requestsFromClub]
(@stadiumName VARCHAR(20),
@clubName    VARCHAR(20))
RETURNS @t TABLE (
    hosting_club_name VARCHAR(20),
    competing_club_name VARCHAR(20)
)
BEGIN 
    INSERT INTO @t
    SELECT H.name, C.name
    FROM managers M
    INNER JOIN stadiums S
    ON M.s_id = S.s_id
    INNER JOIN request Req
    ON M.m_id = Req.m_id
    INNER JOIN matches G
    ON G.g_id = Req.g_id
    INNER JOIN clubs H
    ON H.c_id = G.Host
    INNER JOIN clubs C
    ON C.c_id = G.Guest
    WHERE S.name = @stadiumName AND    H.name = @clubName

    RETURN
END
GO

---login webform procedures
CREATE PROCEDURE login 
@username VARCHAR(20),
@password VARCHAR(20),
@type VARCHAR(20) OUTPUT,
@success BIT OUTPUT
AS 
IF EXISTS ( SELECT * 
            FROM users
            WHERE @username = username AND @password = password)

BEGIN
    
    IF EXISTS ( SELECT *
                FROM fans
                WHERE username = @username
                )
    BEGIN
        IF EXISTS ( SELECT *
        FROM fans
        WHERE username = @username
        AND status = 1
        )
        BEGIN
            SET @success = 1;
            SET @type = 'fan';
        END
        ELSE
        BEGIN
            SET @success = 0;
            SET @type = 'fan';
        END
    END
    
    ELSE IF EXISTS (SELECT *
                    FROM System_admin
                    WHERE username = @username
                    )
    BEGIN
    SET @success = 1;
    SET @type = 'system_admin';
    END

    ELSE IF EXISTS (SELECT *
                    FROM Representative
                    WHERE username = @username
                    )
    BEGIN
    SET @success = 1;
    SET @type = 'representative';
    END

    ELSE IF EXISTS (SELECT *
                    FROM managers
                    WHERE username = @username
                    )
    BEGIN
    SET @success = 1;
    SET @type = 'manager';
    END

    ELSE IF EXISTS (SELECT *
                    FROM Association_Manager
                    WHERE username = @username
                    )
    BEGIN
    SET @success = 1;
    SET @type = 'association_manager';
    END
END
ELSE 
BEGIN
    SET @success = 0;
    SET @type ='';
END
GO
--drop procedure login;


--registeration webform procedures
--insert username and password
CREATE PROCEDURE addNewUserProc
@username VARCHAR(20),
@password VARCHAR(20),
@success BIT OUTPUT,
@error VARCHAR(200) OUTPUT
AS
IF @username NOT IN (SELECT username FROM users)
BEGIN
    IF @password LIKE '________%' 
       AND @password LIKE '%[A-Za-z]%' 
       AND @password > upper(@password) COLLATE Latin1_General_Bin
       AND @password < lower(@password) COLLATE Latin1_General_Bin
       AND @password LIKE '%[0-9]%' 
       AND @password LIKE '%[^a-zA-Z0-9]%' 
       AND @password NOT LIKE '%'  + @username +'%'
       
    BEGIN
        SET @success = 1;
        INSERT INTO users
        VALUES (@username,@password);
    END
    ELSE
    BEGIN
        SET @success =0;
        SET @error = 'password must'
        IF  @password NOT LIKE '________%'
        BEGIN
            SET @error = @error + CHAR(13)+ 'be at least 8 characters in length'
        END
        IF  @password NOT LIKE '%[A-Za-z]%' 
            OR @password <= upper(@password) COLLATE Latin1_General_Bin
            OR @password >= lower(@password) COLLATE Latin1_General_Bin
            OR @password NOT LIKE '%[0-9]%' 
            OR @password NOT LIKE '%[^a-zA-Z0-9]%' 
        BEGIN
            SET @error = @error + CHAR(13)+ 'contain upper & lower case, numeric & special charchters'
        END
        IF @password LIKE '%'  + @username +'%'
        BEGIN
            SET @error = @error + CHAR(13)+ 'not contain username'
        END
    END
END 
ELSE
BEGIN
    SET @success = 0;
    SET @error = 'username not available'
END
GO



CREATE PROCEDURE addAssociationManagerProc
@name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20),
@success BIT OUTPUT,
@error VARCHAR(200) OUTPUT
AS
EXEC addNewUserProc @username = @username, @password = @password, @success = @success OUTPUT, @error = @error OUTPUT;
IF @success = 1
BEGIN
    INSERT INTO Association_Manager VALUES(@username,@name)
END
GO

CREATE PROCEDURE addRepresentativeProc 
@name varchar(20),
@Clubname varchar(20),
@username varchar(20),
@password varchar(20),
@success BIT OUTPUT,
@error VARCHAR(200) OUTPUT
AS
IF EXISTS  (SELECT C_ID 
            FROM Clubs
            WHERE name = @Clubname)
BEGIN
    declare @club_id AS INT 
    SET @club_id = (
    SELECT C_ID 
    FROM Clubs
    WHERE name = @Clubname
    )
    EXEC addNewUserProc @username = @username, @password = @password, @success = @success OUTPUT, @error = @error OUTPUT;
    IF @success = 1
    BEGIN
        insert into Representative values(@username,@club_id,@name)
    END
END
ELSE
BEGIN
    SET @success = 0
    SET @error = 'club does not exist'
END

GO


CREATE PROCEDURE addStadiumManagerProc
@name varchar(20),
@stadium_name varchar(20),
@username varchar(20),
@password varchar(20),
@success BIT OUTPUT,
@error VARCHAR(200) OUTPUT
AS
IF EXISTS  (SELECT S_ID
            FROM Stadiums 
            WHERE Name=@stadium_name)
BEGIN
    DECLARE @stadium_id AS INT
    set @stadium_id=(
    SELECT s.S_ID
    FROM Stadiums s
    WHERE s.Name=@stadium_name
    )
    EXEC addNewUserProc @username = @username, @password = @password, @success = @success OUTPUT, @error = @error OUTPUT;
    IF @success = 1
    BEGIN
        INSERT INTO Managers VALUES (@username,@name,@stadium_id)
    END
END
ELSE
BEGIN
    SET @success = 0
    SET @error = 'stadium does not exist'
END
GO


CREATE PROCEDURE addFanProc
@name varchar(20),
@username varchar(20),
@password varchar(20),
@nationalid varchar(20),
@birthdate datetime,
@address varchar(20),
@phone int,
@success BIT OUTPUT,
@error VARCHAR(200) OUTPUT
AS
IF @nationalid LIKE '______________'
BEGIN
    IF @nationalid NOT IN (SELECT national_id FROM Fans)
    BEGIN
        EXEC addNewUserProc @username = @username, @password = @password, @success = @success OUTPUT, @error = @error OUTPUT;
        IF @success = 1
        BEGIN
        INSERT INTO Fans (username,national_id,Name, Birthdates, address, phone_number) Values(@username,@nationalid,@name,@birthdate,@address,@phone);
        END
    END
    ELSE
    BEGIN
        SET @success = 0;
        SET @error = 'this national id is already linked to an existing account'
    END
END
ELSE
BEGIN
    SET @success = 0
    SET @error = 'national id must be a 14 digit number'
END
GO




--Association Mangager webform procedures
CREATE PROCEDURE addNewMatchProc
@HostClub VARCHAR(20),
@GuestClub VARCHAR(20),
@startTime datetime,
@EndTime datetime,
@success BIT OUTPUT,
@error VARCHAR(40) OUTPUT
AS

IF EXISTS (SELECT * FROM clubs WHERE name = @HostClub)
BEGIN
    IF EXISTS (SELECT * FROM clubs WHERE name = @GuestClub)
    BEGIN  
        
        declare @Club1 AS int;
        set @Club1 = (SELECT C_ID 
        FROM Clubs C
        WHERE C.Name = @HostClub);
        declare @Club2 AS int;
        set @Club2 = (SELECT C_ID 
        FROM Clubs C
        WHERE C.Name = @GuestClub);

        IF EXISTS (SELECT * FROM Matches WHERE Host = @Club1 AND Guest = @Club2 AND starting_time = @startTime AND ending_time = @EndTime)
        BEGIN
            SET @success = 0;
            SET @error = 'Match already exists.';
        END
        ELSE
        IF (@startTime > @EndTime)
        BEGIN
            SET @success = 0;
            SET @error = 'start time must be before endtime';
        END
        ELSE
        BEGIN
            SET @success = 1;
            INSERT INTO Matches VALUES(@startTime,@EndTime,NULL,NULL,@Club1,@Club2)
        END
    END
    ELSE
    BEGIN
        SET @success = 0;
        SET @error = @GuestClub + ' does not exist'
    END
END
ELSE 
BEGIN
    IF EXISTS (SELECT * FROM clubs WHERE name = @GuestClub)
    BEGIN
        SET @success = 0;
        SET @error = @HostClub + ' does not exist'
    END
    ELSE
    BEGIN
        SET @success = 0;
        SET @error = @HostClub + ' and ' + @GuestClub + ' do not exist'  
    END
END
--drop procedure addNewMatchProc
GO


CREATE PROCEDURE deleteMatchProc
@HostClub VARCHAR(20),
@GuestClub VARCHAR(20),
@startTime datetime,
@endTime datetime,
@success BIT OUTPUT,
@error VARCHAR(40) OUTPUT

AS

IF EXISTS (SELECT * FROM clubs WHERE name = @HostClub)
BEGIN
    IF EXISTS (SELECT * FROM clubs WHERE name = @GuestClub)
    BEGIN
        declare @Club1 AS int;
        set @Club1 = (SELECT C_ID 
        FROM Clubs C1
        WHERE C1.Name = @HostClub);
        declare @Club2 AS int;
        set @Club2 = (SELECT C_ID 
        FROM Clubs C2
        WHERE C2.Name = @GuestClub);

        IF EXISTS (SELECT * FROM Matches M WHERE M.Host = @Club1 AND M.Guest = @Club2 AND M.starting_time = @startTime AND M.ending_time = @endTime)
        BEGIN
            SET @success = 1;
            DELETE FROM Matches 
            WHERE Host = @Club1 AND Guest = @Club2 AND starting_time = @startTime AND ending_time = @endTime;
        END
        ELSE
        BEGIN
            SET @success = 0;
            SET @error = 'match does not exist';
        END
            
    END
    ELSE
    BEGIN
        SET @success = 0;
        SET @error = @GuestClub + ' does not exist'
    END
END
ELSE 
BEGIN
    IF EXISTS (SELECT * FROM clubs WHERE name = @GuestClub)
    BEGIN
        SET @success = 0;
        SET @error = @HostClub + ' does not exist'
    END
    ELSE
    BEGIN
        SET @success = 0;
        SET @error = @HostClub + ' and ' + @GuestClub + ' do not exist'  
    END
END
--drop procedure deleteMatchProc 

GO


CREATE PROCEDURE viewUpcomingMatches 
AS
SELECT C1.name AS host , C2.name AS guest, M.starting_time, M.ending_time
FROM Matches M
INNER JOIN Clubs C1
ON M.Host = C1.C_ID
INNER JOIN Clubs C2
ON M.Guest = C2.C_ID
WHERE starting_time > CURRENT_TIMESTAMP;
GO
--drop procedure viewUpcomingMatches;

CREATE PROCEDURE viewAlreadyPlayedMatches
AS
SELECT C1.name AS host , C2.name AS guest, M.starting_time, M.ending_time
FROM Matches M
INNER JOIN Clubs C1
ON M.Host = C1.C_ID
INNER JOIN Clubs C2
ON M.Guest = C2.C_ID
WHERE starting_time < CURRENT_TIMESTAMP;
GO
--drop procedure viewAlreadyPlayedMatches

CREATE VIEW clubsNeverScehduledToMatch  AS
SELECT C1.name AS 'firstclub', C2.name AS 'secondclub'
FROM Clubs C1 ,Clubs C2
WHERE C1.C_ID <> C2.C_ID AND C1.C_ID < C2.C_ID AND
NOT EXISTS(SELECT Host, Guest
		   FROM Matches M
		   WHERE (C1.C_ID = M.Host OR C1.C_ID = M.Guest) 
		   AND (C2.C_ID = M.Host OR C2.C_ID = M.Guest))
GO
--drop view clubsNeverScehduledToMatch;

CREATE PROCEDURE clubsNeverScehduledToMatchProc AS
SELECT * FROM clubsNeverScehduledToMatch
GO
--drop procedure clubsNeverScehduledToMatchProc;



CREATE PROCEDURE dropAllProceduresFunctionsViews AS
DROP PROCEDURE createAllTables
DROP PROCEDURE dropAllTables
DROP PROCEDURE clearAllTables
DROP PROCEDURE addAssociationManager
DROP PROCEDURE addNewMatch
DROP VIEW clubsWithNoMatches
DROP PROCEDURE  deleteMatch
DROP PROCEDURE deleteMatchesOnStadium
DROP PROCEDURE addClub
DROP PROCEDURE addTicket
DROP PROCEDURE deleteClub
DROP PROCEDURE addStadium
DROP PROCEDURE deleteStadium
DROP PROCEDURE blockFan
DROP PROCEDURE unblockFan
DROP PROCEDURE addRepresentative
DROP function viewAvailableStadiumsOn
DROP PROCEDURE addHostRequest
DROP function allUnassignedMatches
DROP PROCEDURE addStadiumManager
DROP function allPendingRequests
DROP PROCEDURE acceptRequest
DROP PROCEDURE rejectRequest
DROP PROCEDURE addFan
DROP function upcomingMatchesOfClub
DROP function availableMatchesToAttend
DROP PROCEDURE purchaseTicket
DROP PROCEDURE updateMatchHost
DROP PROCEDURE deleteMatchesOnStadium
DROP VIEW  matchesPerTeam,clubsNeverMatched, allAssocManagers, allClubRepresentatives,allStadiumManagers,allFans,allMatches,allTickets,allCLubs,allStadiums,allRequests
DROP function clubsNeverPlayed,matchWithHighestAttendance,matchesRankedByAttendance,requestsFromClub
GO
--exec dropAllProceduresFunctionsViews;




EXEC clearAllTables;

INSERT INTO users 
VALUES ('admin', 'admin');
INSERT INTO System_admin
VALUES ('admin');

go
--kika's procedures
CREATE PROCEDURE info 
@username varchar(20)
as
SELECT c.C_ID,c.name,c.location
FROM Representative r inner join clubs c on r.C_ID=c.C_ID
WHERE r.username=@username

GO 

CREATE PROCEDURE availableafter
@date datetime
as
SELECT S.Name,S.Location,S.Capacity
FROM Stadiums S 
WHERE S.Status = 1
EXCEPT
SELECT S1.Name, S1.Location, S1.Capacity
FROM Stadiums S1 INNER JOIN Matches M ON M.S_ID = S1.S_ID AND M.ending_time >= @date

GO 

CREATE PROCEDURE exist
@name varchar(20),
@flag bit output
AS
if(exists(SELECT * FROM Clubs WHERE name=@name))
BEGIN
set @flag = 1;
END
ELSE
BEGIN
set @flag=0;
END

GO

CREATE PROCEDURE upcomingMatch
@username varchar(20)
AS 
SELECT c1.name AS Host ,c2.name AS Guest,starting_time,ending_time,s.Name AS Stadium
FROM Matches m inner join Clubs c1 on m.Host=c1.C_ID inner join Clubs c2 on m.Guest=c2.C_ID left outer join Stadiums s on m.S_ID=s.S_ID , Representative r
WHERE ((m.Host=r.C_ID) or(m.Guest=r.C_ID)) and m.starting_time>CURRENT_TIMESTAMP and r.username=@username

GO

CREATE PROCEDURE Req
@username varchar(20),
@stadiumName varchar(20),
@date datetime,
@flag BIT OUTPUT,
@flag1 BIT OUTPUT
AS


DECLARE @S_ID AS INT 
SET @S_ID = (
SELECT S_ID 
FROM Stadiums 
WHERE name = @stadiumName
)

DECLARE @R_ID AS INT 
SET @R_ID = (
SELECT R_ID 
FROM Representative 
WHERE username = @username
)
DECLARE @C_ID AS INT 
SET @C_ID = (
SELECT C_ID 
FROM Representative 
WHERE username = @username
)
DECLARE @G_ID AS INT 
SET @G_ID = (
SELECT G_ID
FROM Matches
WHERE starting_time = @date AND Host = @C_ID
)
DECLARE @M_ID AS INT
SET @M_ID = (
SELECT M_ID 
FROM Managers 
WHERE S_ID = @S_ID
)
if @G_ID is not null
BEGIN
    SET @flag=1
END
ELSE
BEGIN
    SET @flag=0
END

if @S_ID is not null
BEGIN
    SET @flag1=1
END
ELSE
BEGIN
SET @flag1=0
END

IF @S_ID is not null and @G_ID is not null
BEGIN
insert into request (G_ID, R_ID, M_ID) values(@G_ID,@R_ID,@M_ID)
END
drop procedure Req;
GO

CREATE PROCEDURE checkstadium
@name varchar(20),
@flag BIT OUTPUT
AS 
IF(Exists(SELECT * FROM Stadiums s WHERE s.Name=@name))
BEGIN
SET @flag=1;
END
ELSE
BEGIN
SET @flag=0;
END

GO

CREATE PROCEDURE checkfan
@nationalid varchar(20),
@flag BIT OUTPUT
AS
IF (EXISTS(SELECT * FROM Fans WHERE national_id=@nationalid))
BEGIN
SET @flag=1;
END
ELSE 
BEGIN
SET @flag=0;
END

GO

--maged's procedure
CREATE PROCEDURE viewMyStadium
@username VARCHAR(20)
AS
SELECT S.*
FROM Stadiums S INNER JOIN Managers M ON M.S_ID = S.S_ID AND M.username = @username
GO

CREATE PROCEDURE ReceivedReq 
@username VARCHAR(20)
AS
SELECT rep.name AS 'Representative_Name' ,C.name AS 'Host_name',guest.name AS 'guest_name' ,ma.starting_time,ma.ending_time,req.response AS 'Status'
FROM request Req INNER JOIN Managers M ON Req.M_ID = M.M_ID and M.username = @username
inner join Representative rep on rep.R_ID = req.R_ID
inner join Clubs C ON c.C_ID = Rep.C_ID 
inner join Matches Ma on Ma.G_ID = Req.G_ID
inner join Clubs guest on guest.C_ID = ma.Guest
GO


CREATE PROCEDURE rejectRequestProc
@username varchar(20),
@HostName varchar(20),
@GuestName varchar(20),
@startTime varchar(40)
AS 
DECLARE @datetime datetime;
SET @datetime = (SELECT CONVERT(DATETIME,@starttime,104)) 

DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostName
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestName
)
DECLARE @match_id as INT
set @match_id=(
select m.G_ID
from Matches m
WHERE m.Host= @Hid AND m.Guest = @Cid AND m.starting_time=@datetime
)
DECLARE @mang_id as int
set @mang_id=(
select m.M_ID
FROM Managers m
WHERE m.username=@username
)

UPDATE request
SET response='rejected'
WHERE @match_id=request.G_ID and @mang_id=M_ID and response = 'unhandled'
GO


CREATE PROCEDURE acceptRequestProc
@username varchar(20),
@HostClub varchar(20),
@GuestClub varchar(20),
@datetime varchar(40)
AS 
DECLARE @datetime2 datetime;
SET @datetime2 = (SELECT CONVERT(DATETIME,@datetime,104)) 

DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostClub
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestClub
)
DECLARE @match_id as INT
set @match_id=(
select m.G_ID
from Matches m
WHERE m.Host= @Hid AND m.Guest = @Cid AND m.starting_time=@datetime2
)
DECLARE @mang_id as int
set @mang_id=(
select m.M_ID
FROM Managers m
WHERE m.username=@username
)
DECLARE @stadium_id as int
set @stadium_id =(
SELECT S_ID
FROM Managers
WHERE M_ID = @mang_id)

DECLARE @CAP as int 
SET @CAP =(
SELECT Capacity
FROM Stadiums
WHERE S_ID = @stadium_id)

If EXISTS (SELECT * 
           FROM request
           WHERE @match_id=G_ID and @mang_id=M_ID and response = 'unhandled')
BEGIN 
    UPDATE request
    SET response='accepted'
    WHERE @match_id=request.G_ID and @mang_id=M_ID
    UPDATE Matches
    SET S_ID = @stadium_id , allowed_number_of_attendees = @CAP
    WHERE G_ID = @match_id AND S_ID is NULL
    
    DECLARE @i int = 0
    WHILE @i < @CAP
    BEGIN
        SET @i = @i + 1
        EXEC addTicket @hostClubName =  @HostClub, @guestClubName = @GuestClub ,@startTime = @datetime2;
    END
    

END
GO

--safwat's procedure
CREATE PROCEDURE viewAvailableMatches
@date datetime
AS
SELECT DISTINCT h.name,c.name,m.starting_time,s.Location
FROM Matches m inner join Clubs h on m.Host=h.C_ID 
inner join Clubs c on m.Guest=c.C_ID 
inner join Stadiums s on m.S_ID=s.S_ID 
inner join Tickets t on s.S_ID=t.S_ID and t.G_ID=m.G_ID
where m.starting_time >= @date and EXISTS(
select t1.T_ID
from Tickets t1
where t1.status=1 and t.T_ID=t1.T_ID
)
GO

CREATE PROCEDURE purchaseTicketProc
@username VARCHAR(20),
@HostClub varchar(20),
@GuestClub varchar(20),
@date datetime,
@flag VARCHAR(100) OUTPUT
AS
DECLARE @nationalid AS VARCHAR(20)
SET @nationalid = (
SELECT national_id
FROM Fans
WHERE username = @username
)
DECLARE @Hid AS INT
SET @Hid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @HostClub
)
DECLARE @Cid AS INT
SET @Cid = (
SELECT C_ID 
FROM Clubs 
WHERE name = @GuestClub
)
DECLARE @Mid AS INT
SET @Mid = (
SELECT G_ID 
FROM Matches 
WHERE starting_time = @date AND (Host = @Hid AND Guest = @Cid) AND starting_time >= CURRENT_TIMESTAMP
)

DECLARE @Sid AS INT
SET @Sid = (
SELECT S_ID 
FROM Matches 
WHERE starting_time = @date AND (Host = @Hid AND Guest = @Cid)
)

DECLARE @Tid AS INT 
SET @Tid = (
SELECT TOP 1 T_ID
FROM Tickets 
WHERE G_ID = @Mid and status = 1
)
IF @Sid IS NOT NULL AND NOT EXISTS (SELECT * FROM Tickets WHERE G_ID = @Mid and status = 1)  BEGIN
set @flag = 'No Tickets available'
END
ELSE BEGIN
IF @Mid is null begin
set @flag = 'No matches available'
end
ELSE begin
set @flag = 'Ticket Purchased Successfully'
UPDATE Tickets
set status = 0, national_ID = @nationalID
where T_ID = @Tid AND G_ID = @Mid
end
END