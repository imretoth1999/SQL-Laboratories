USE PracticalExam3
go



IF OBJECT_ID('Airc','U') IS NOT NULL
	DROP TABLE Airc
IF OBJECT_ID('Aircm','U') IS NOT NULL
	DROP TABLE Aircm
IF OBJECT_ID('c_d','U') IS NOT NULL
	DROP TABLE c_d
	IF OBJECT_ID('Company','U') IS NOT NULL
	DROP TABLE Company
	IF OBJECT_ID('HolidayD','U') IS NOT NULL
	DROP TABLE HolidayD
GO

Create Table HolidayD(Hd int primary key identity(1,1),
name VARCHAR(100))
Create table Company(Cid int primary key identity(1,1),
name varchar(100),c_type varchar(100))
Create table Aircm(Aid int primary key identity(1,1),
name varchar(100),avg_w int)
Create table Airc(A int primary key identity(1,1),
color varchar(100),n_seats int,a_m int references Aircm(Aid),cm int references Company(Cid))
Create table c_d
(
	Hd int references HolidayD(Hd),
	Cid int references Company(Cid),
	WeeklyFlights int ,
	Primary key (Hd,Cid))


INSERT INTO HolidayD(name) VALUES('floresti')
INSERT INTO HolidayD(name) VALUES('Cluj')
INSERT INTO Company(name,c_type) VALUES('CTP','high-cost')
INSERT INTO Company(name,c_type) VALUES('RTB','low-cost')
INSERT INTO Company(name,c_type) VALUES('CV','high-cost')
INSERT INTO Company(name,c_type) VALUES('NV','low-cost')
INSERT INTO Aircm(name,avg_w) VALUES('vrumvrum',1)
INSERT INTO Aircm(name,avg_w) VALUES('miau1',33)
INSERT INTO Airc(color,n_seats,a_m,cm) VALUES('blue',10,1,1)
INSERT INTO Airc(color,n_seats,a_m,cm) VALUES('red',122,2,1)

INSERT INTO c_d(Hd,Cid,WeeklyFlights) VALUES(1,1,11)
INSERT INTO c_d(Hd,Cid,WeeklyFlights) VALUES(1,2,12)
SELECT * FROM HolidayD
go
CREATE OR ALTER PROCedure addDC @c varchar(100),@d varchar(100),@f int
as 
	DECLARE @CID int = (SELECT Cid FROM Company WHERE name = @c),
			@HD int =(SELECT Hd FROM HolidayD WHERE name = @d)
	if @CID is NULL OR @HD is NULL
		RAISERROR('CID OR HD IS NULL',16,1)
	ELSE 
		IF EXISTS (SELECT * FROM c_d  WHERE Cid = @CID and Hd = @HD)
			RAISERROR('There are already flights',16,1)
		ELSE 
			INSERT c_d(Hd,Cid,WeeklyFlights) VALUES (@HD,@CID,@f)
go
exec addDC 'CV','Floresti',12
SELECT * FROM c_d
GO
CREATE OR ALTER FUNCTION getD(@d INT)
RETURNS TABLE
RETURN SELECT C.name
FROM Company C
 WHERE C.cid IN(
SELECT cd.Cid FROM c_d cd 
GROUP BY cd.Cid
HAVING COUNT(*) > @d
)
go
SELECT * FROM getD(0)
