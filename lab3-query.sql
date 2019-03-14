--1
create function checkInt(@n int)
returns int as
begin
declare @no int
if @n>0 and @n<=40
set @no=1
else
set @no=0
return @no
end
go 

create function checkVarchar(@v varchar(50))
returns bit as
begin
declare @b bit
if @v LIKE '[a-z]%[a-z]'
set @b=1
else
set @b=0
return @b
end
go



create procedure addPolice @v varchar(50), @e varchar(50), @n int
AS
Begin
-- validate the parameters @g, @n, @r - at least 2 parameters
if dbo.checkInt(@n)=1 and dbo.checkVarchar(@v)=1
begin
INSERT INTO PoliceStation(PSID,stationAddress,stationRating) Values (@v, @e, @n)
print 'VALUE ADDED'
select * from PoliceStation
end
else
begin
print @n
print @v
select * from PoliceStation
end
end
go

create procedure addEmployee @eid varchar(50), @fname varchar(50),@lname varchar(50),@hw int,@cs int,@d date, @p varchar(50)
AS
Begin
-- validate the parameters @g, @n, @r - at least 2 parameters
if dbo.checkInt(@hw)=1 and dbo.checkVarchar(@p)=1
begin
INSERT INTO EMPLOYEE Values(@eid,@fname,@lname,@hw,@cs,@d,@p)
print 'VALUE ADDED'
select * from EMPLOYEE
end
else
begin
print 'VALUE ADDED'
select * from EMPLOYEE
end
end
go

create view vAll
as
SELECT g.PSID,s.EID,e.NumberOfCases,c.DateOfAdmission
from PoliceStation g inner join EMPLOYEE s on
s.PSID=g.PSID
inner join EmployeeCases1 e on e.EID=s.EID
inner join GunLicense c on c.EID=e.EID
go

exec addPolice @v='VV',@e='Floresti',@n=5
exec addEmployee '42','Im','Tot',22,22,'10/10/10','CV'
exec addPolice @v='CE',@e='123',@n=5
exec addEmployee '42','Im','Tot',22,22,'10/10/10','CV'
--2
select * from vAll
--3

go
CREATE TRIGGER Add_Station ON PoliceStation FOR INSERT
 AS
BEGIN
INSERT INTO Logs(Date,Type,AffTable,AffRows) VALUES(GetDate(),'INSERT','PoliceStation',@@ROWCOUNT)
END
go

go
CREATE TRIGGER Delete_Station ON PoliceStation FOR Delete
 AS
BEGIN
INSERT INTO Logs(Date,Type,AffTable,AffRows) VALUES(GetDate(),'DELETE','PoliceStation',@@ROWCOUNT)
END
GO

CREATE TRIGGER Update_Station ON PoliceStation FOR UPDATE
 AS
BEGIN
INSERT INTO Logs(Date,Type,AffTable,AffRows) VALUES(GetDate(),'UPDATE','PoliceStation',@@ROWCOUNT)
END
GO

go
CREATE TRIGGER Add_Employee ON EMPLOYEE FOR INSERT
 AS
BEGIN
INSERT INTO Logs(Date,Type,AffTable,AffRows) VALUES(GetDate(),'INSERT','EMPLOYEE',@@ROWCOUNT)
END
GO


go
CREATE TRIGGER Delete_Employee ON EMPLOYEE FOR Delete
 AS
BEGIN
INSERT INTO Logs(Date,Type,AffTable,AffRows) VALUES(GetDate(),'DELETE','EMPLOYEE',@@ROWCOUNT)
END
GO
INSERT INTO PoliceStation(PSID,stationAddress,stationRating) VALUES('3','2',4)
INSERT INTO EMPLOYEE VALUES(321,'Prenume','Nume',33,1,'10/10/99','1')
DELETE FROM EMPLOYEE WHERE EID = 421
DELETE FROM PoliceStation WHERE PSID = '3'
UPDATE PoliceStation SET stationRating = 6 WHERE PSID = '1'
SELECT * FROM Logs
-- 4
select * from sys.sql_modules
select * from sys.objects
