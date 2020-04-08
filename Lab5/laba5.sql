CREATE TABLE HierarchyidTable(
  hid hierarchyid NOT NULL PRIMARY KEY,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
);

insert into HierarchyidTable values(hierarchyid::GetRoot(), 1, 'Иванов');

declare @Id hierarchyid
select @Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = hierarchyid::GetRoot()
insert into HierarchyidTable values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Петров');

select @Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = hierarchyid::GetRoot()
insert into HierarchyidTable values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'Сидоров');

select @Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = hierarchyid::GetRoot()
insert into HierarchyidTable values(hierarchyid::GetRoot().GetDescendant(@id, null), 4, 'Николаев');

declare @phId hierarchyid

select @phId = (SELECT hid FROM HierarchyidTable WHERE userId = 2);
select Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = @phId
insert into HierarchyidTable values( @phId.GetDescendant(@id, null), 5, 'Смирнов');

select @phId = (SELECT hid FROM HierarchyidTable WHERE userId = 4);
select Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = @phId
insert into HierarchyidTable values( @phId.GetDescendant(@id, null), 6, 'Круглов');

select @phId = (SELECT hid FROM HierarchyidTable WHERE userId = 4);
select @Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = @phId
insert into HierarchyidTable values( @phId.GetDescendant(@id, null), 7, 'Квадратов');

go
create procedure GetSubordinate @id hierarchyid as select hid.GetLevel()[Level], * from HierarchyidTable where hid.IsDescendantOf(@id) = 1

declare @Id hierarchyid
select @Id = hid from HierarchyidTable where userId = 1
EXEC GetSubordinate @id

go
create procedure CreateNode @id hierarchyid, @userid INT, @name NVARCHAR(20) 
as insert into HierarchyidTable values(hierarchyid::GetRoot().GetDescendant(@id, null), @userid, @name);

declare @Id hierarchyid
declare @userid INT
declare @name NVARCHAR(20)
SET @userid = 8
SET @name = 'Попов'
select @Id = MAX(hid) from HierarchyidTable where hid.GetAncestor(1) = hierarchyid::GetRoot()
EXEC CreateNode @Id, @userid, @name

go
create procedure ChangeParent @SubjectEmployee hierarchyid , @OldParent hierarchyid, @NewParent hierarchyid as  
UPDATE HierarchyidTable SET hid = @SubjectEmployee.GetReparentedValue(@OldParent, @NewParent)  WHERE hid= @SubjectEmployee ;  

DECLARE @SubjectEmployee hierarchyid , @OldParent hierarchyid, @NewParent hierarchyid, @hid hierarchyid   
SELECT @SubjectEmployee = hid FROM HierarchyidTable WHERE userId = 5; 
SELECT @OldParent = hid FROM HierarchyidTable  WHERE userId = 2
SELECT @NewParent = hid FROM HierarchyidTable  WHERE userId = 3
EXEC ChangeParent @SubjectEmployee, @OldParent, @NewParent

--XML
