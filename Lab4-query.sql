

use PoliceStations
Go
CREATE TABLE Culprit(-- Ta
Cuid INT PRIMARY KEY IDENTITY, -- aid
Name VARCHAR(50),
Age INT, -- a2
caseid INT UNIQUE
)
CREATE TABLE Jail_room(-- Tb
Jid INT PRIMARY KEY IDENTITY, -- bid
Jname VARCHAR(50),
RoomNr INT-- b2
)
CREATE TABLE Distributions(-- Tc
Did INT PRIMARY KEY IDENTITY, -- cid
Cid INT FOREIGN KEY REFERENCES Culprit(Cuid), -- aid
Pid INT FOREIGN KEY REFERENCES Jail_room(Jid) -- bid
)
select * from Culprit 
select * from Jail_room
select * from DistributionsIF EXISTS (SELECT name FROM sys.indexes WHERE name = 'N_idx_Name')
 DROP INDEX N_idx_Name ON Jail_room;
GO

CREATE NONCLUSTERED INDEX N_idx_Name ON Jail_room(Jname);
GO--index scanselect * from Culprit order by Cuid--key lookupselect * from Culprit order by  caseid--index seekselect Cuid,Name from Culprit where caseid = 10-- check the indexes (nonclustered) for the database used
SELECT TableName = t.name, IndexName = ind.name, IndexId = ind.index_id, ColumnId = ic.index_column_id,
 ColumnName = col.name, ind.*, ic.*, col.*
FROM sys.indexes ind
INNER JOIN sys.index_columns ic ON ind.object_id = ic.object_id and ind.index_id = ic.index_id
INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id
INNER JOIN sys.tables t ON ind.object_id = t.object_id
WHERE ind.is_primary_key = 0 AND ind.is_unique = 0 AND ind.is_unique_constraint = 0
 AND t.is_ms_shipped = 0
ORDER BY t.name, ind.name, ind.index_id, ic.index_column_id;-- all the indexes from table Culprit
select i2.name, i1.user_scans, i1.user_seeks, i1.user_updates,i1.last_user_scan,i1.last_user_seek,
i1.last_user_update
from sys.dm_db_index_usage_stats i1
inner join sys.indexes i2 on i1.index_id = i2.index_id
where i1.object_id = OBJECT_ID('Culprit') and i1.object_id = i2.object_id


-- all the indexes from the current database
SELECT OBJECT_NAME(A.[OBJECT_ID]) AS [OBJECT NAME], I.[NAME] AS [INDEX NAME], A.LEAF_INSERT_COUNT,
 A.LEAF_UPDATE_COUNT, A.LEAF_DELETE_COUNT
FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS (NULL,NULL,NULL,NULL ) A
 INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = A.[OBJECT_ID] AND I.INDEX_ID = A.INDEX_ID
WHERE OBJECTPROPERTY(A.[OBJECT_ID],'IsUserTable') = 1
INSERT INTO Jail_room(Jname,RoomNr) VALUES('Azkaban',100)

IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'N_idx_Room')
 DROP INDEX N_idx_Room ON Jail_room;
GO
-- Create a nonclustered index called N_idx_Room on the Jail_room table using the Price column.
CREATE NONCLUSTERED INDEX N_idx_Room ON Jail_room(RoomNr);
GO

-- second task with index on the roomnr
select *
from Jail_room
where RoomNr=100

GO
SET NOCOUNT ON;
GO
SET SHOWPLAN_ALL ON;
GO
--
SELECT * FROM Jail_room WHERE RoomNr BETWEEN 45 AND 115;
GO
--
SET SHOWPLAN_ALL OFF
GO


select c.Name, c.Age, j.Jname, j.RoomNr
from Culprit c INNER JOIN Distributions d ON c.Cuid=d.Cid
INNER JOIN Jail_room j ON j.Jid=d.Pid
Where Age BETWEEN 20 and 44 OR RoomNr>49

-- Find an existing index named N_idx_Name and delete it if found.
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'N_idx_Name')
 DROP INDEX N_idx_Name ON Culprit;
GO
-- Create a nonclustered index called N_idx_Color on the Presents table using the Color column.
CREATE NONCLUSTERED INDEX N_idx_Name ON Culprit(Name);
GOselect c.Name
from Culprit c INNER JOIN Distributions d ON c.Cuid=d.Cid
INNER JOIN Jail_room j ON j.Jid=d.Pid
Where Age BETWEEN 20 and 44 OR RoomNr>49-- CHECK THE INDEXES WITH SP_INDEXES
EXEC sp_indexes @table_server='sysname', --'sys.servers'
@table_name='Culprit',
@table_schema='dbo',
@table_catalog='PoliceStations'

EXEC sp_helpindex 'Culprit'