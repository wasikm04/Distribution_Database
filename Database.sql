/*Kod do Projektu, Maciej Wasik*/

/****************/
/*Usuwanie Tabel*/
/****************/

exec pr_rmv_procedure @procedure_name='pr_rmv_table'
exec pr_rmv_procedure @procedure_name='pr_rmv_trigger'
exec pr_rmv_procedure @procedure_name='pr_rmv_procedure'

CREATE PROCEDURE [dbo].pr_rmv_table(@table_name nvarchar(100))
AS
	DECLARE @stmt1 nvarchar(1000)
	IF EXISTS 
	( SELECT 1
		FROM sysobjects o
		WHERE	(o.[name] = @table_name)
		AND	(OBJECTPROPERTY(o.[ID],'IsUserTable')=1)
	)
	BEGIN
		SET @stmt1 = 'DROP TABLE ' + @table_name
		EXECUTE sp_executeSQL @stmt1 = @stmt1
		Print 'Usuniêto Tabele' +@table_name
	END
GO

exec pr_rmv_table @table_name='ZamowieniaP'
exec pr_rmv_table @table_name='ProduktyP'
exec pr_rmv_table @table_name='DostawyP'
exec pr_rmv_table @table_name='DostawcyP'
exec pr_rmv_table @table_name='MagazynyP'
exec pr_rmv_table @table_name='SklepyP'
exec pr_rmv_table @table_name='MiastaP'
exec pr_rmv_table @table_name='WojewodztwaP'

/*******************/
/*Usuwanie Procedur*/
/*******************/

CREATE PROCEDURE [dbo].pr_rmv_procedure(@procedure_name nvarchar(100))
AS
	DECLARE @stmt2 nvarchar(1000)
	IF EXISTS 
	( SELECT 1
		FROM sysobjects o
		WHERE	(o.[name] = @procedure_name)
		AND	(OBJECTPROPERTY(o.[ID],'IsProcedure')=1)
	)
	BEGIN
		SET @stmt2 = 'DROP PROCEDURE ' + @procedure_name
		EXECUTE sp_executeSQL @stmt2 = @stmt2
		Print 'Usuniêto Procedurê' +@procedure_name
	END
GO

exec pr_rmv_procedure @procedure_name='upDostawcy'
exec pr_rmv_procedure @procedure_name='upZamowienia'
exec pr_rmv_procedure @procedure_name='upProd'
exec pr_rmv_procedure @procedure_name='upSklep'
exec pr_rmv_procedure @procedure_name='upDostawy'
exec pr_rmv_procedure @procedure_name='inWoj'
exec pr_rmv_procedure @procedure_name='inMiasta'
exec pr_rmv_procedure @procedure_name='inMagazyn'
exec pr_rmv_procedure @procedure_name='inSklep'
exec pr_rmv_procedure @procedure_name='inDostawcy'
exec pr_rmv_procedure @procedure_name='inDostawy'
exec pr_rmv_procedure @procedure_name='inProdukt'
exec pr_rmv_procedure @procedure_name='inZamowienia'
exec pr_rmv_procedure @procedure_name='ExtendedInProduct'
exec pr_rmv_procedure @procedure_name='ExtendedInTransaction'



/********************/
/*Usuwanie Triggerów*/
/********************/
CREATE PROCEDURE [dbo].pr_rmv_trigger(@trigger_name nvarchar(100))
AS
	DECLARE @stmt3 nvarchar(1000)
	IF EXISTS 
	( SELECT 1
		FROM sysobjects o
		WHERE	(o.[name] = @trigger_name)
		AND	(OBJECTPROPERTY(o.[ID],'IsTrigger')=1)
	)
	BEGIN
		SET @stmt3 = 'DROP TRIGGER ' + @trigger_name
		EXECUTE sp_executeSQL @stmt3 = @stmt3
		Print 'Usuniêto Trigger' +@trigger_name
	END
GO

exec pr_rmv_trigger @trigger_name='CostTrigger'
exec pr_rmv_trigger @trigger_name='AddTransactionTrigger'
exec pr_rmv_trigger @trigger_name='DeleteProductTrigger'
exec pr_rmv_trigger @trigger_name='DeleteTransactionTrigger'
exec pr_rmv_trigger @trigger_name='UpdateProductTrigger'
exec pr_rmv_trigger @trigger_name='UpdateShopTrigger'
exec pr_rmv_trigger @trigger_name='UpdateDeliveryTrigger'
exec pr_rmv_trigger @trigger_name='UpdateTransactionTrigger'


/*****************/
/*Tworzenie Tabel*/
/*****************/
CREATE TABLE dbo.WojewodztwaP 
( 
Id_woj NVARCHAR(3) NOT NULL PRIMARY KEY,
NAZWA NVARCHAR(20) NOT NULL 
) 

CREATE TABLE dbo.MiastaP 
( 
Id_miasta NVARCHAR(3) NOT NULL PRIMARY KEY, 
KOD_woj NVARCHAR(3) FOREIGN KEY REFERENCES WojewodztwaP(Id_woj), 
NAZWA NVARCHAR(20) NOT NULL 
) 

CREATE TABLE dbo.SklepyP 
( 
Id_sklepu INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Id_miasta NVARCHAR(3) FOREIGN KEY REFERENCES MiastaP(Id_miasta), 
Adres NVARCHAR(30), 
Liczba_produktow INT 
) 

CREATE TABLE dbo.MagazynyP 
( 
Id_magazynu INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Id_miasta NVARCHAR(3) FOREIGN KEY REFERENCES MiastaP(Id_miasta), 
Liczba_produktow INT
) 

CREATE TABLE dbo.DostawcyP 
( 
Id_dostawcy INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Imie_Nazwisko NVARCHAR(20), 
Zajetosc BIT
) 

CREATE TABLE dbo.DostawyP 
( 
Id_dostawy INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Id_dostawcy INT FOREIGN KEY REFERENCES DostawcyP(Id_dostawcy)
) 

CREATE TABLE dbo.ProduktyP 
( 
Id_produktu INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Id_magazynu INT FOREIGN KEY REFERENCES MagazynyP(Id_magazynu), 
Pelna_nazwa NVARCHAR(30), 
Cena INT 
)

CREATE TABLE dbo.ZamowieniaP 
( 
Id_zamowienia INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
Id_sklepu INT FOREIGN KEY REFERENCES SklepyP(Id_sklepu),
Id_produktu INT FOREIGN KEY REFERENCES ProduktyP(Id_produktu),
Id_dostawy INT FOREIGN KEY REFERENCES DostawyP(Id_dostawy),
Ilosc INT, 
Koszt INT,
Zrealizowano BIT 
)


/*****************/
/*Zasilanie Tabel*/
/*****************/

insert into WojewodztwaP(Id_woj,NAZWA)
values
('MAZ','Mazowieckie'),
('POM','Pomorskie'),
('POD','Podkarpackie'),
('SLA','Œl¹skie'),
('WIE','Wielkopolskie')

insert into MiastaP(Id_miasta,KOD_woj,NAZWA)
values
('WAW','MAZ','Warszawa'),
('GDA','POM','Gdañsk'),
('RZE','POD','Rzeszów'),
('KAT','SLA','Katowice'),
('POZ','WIE','Poznañ')

insert into SklepyP(Id_miasta,Adres,Liczba_produktow)
values
('WAW','Prosta 100',100),
('GDA','Solidarnoœci 34',300),
('RZE','D³uga 14',234),
('KAT','Adama Mickiewicza 34',1337),
('POZ','S¹dowa 1',420)

insert into MagazynyP(Id_miasta,Liczba_produktow)
values
('WAW',900),
('GDA',1300),
('RZE',2234),
('KAT',1337),
('POZ',4320)

insert into ProduktyP(Id_magazynu,Pelna_nazwa,Cena)
values
(3,'TRB',900),
(2,'Pralka JH-300 Philips',600),
(3,'Robot Kuchenny Samsung T',400),
(4,'Golarka Philips FK',129),
(5,'Toster Ava',300)

insert into DostawcyP(Imie_Nazwisko,Zajetosc)
values
('Jan Kowalski',0),
('Jurek Nowak',0),
('Anna Konieczna',0),
('Andrzej Nowy',0),
('Juliusz Kowal',0)

insert into DostawyP(Id_dostawcy)
values
(null),
(null),
(null),
(null),
(null)

insert into ZamowieniaP(Id_sklepu,Id_produktu,Id_dostawy,ilosc,koszt,Zrealizowano)
values
(1,1,1,100,20000,0),
(2,3,2,60,35000,0),
(3,3,3,30,17000,0),
(4,4,4,50,23000,0),
(5,5,5,80,7000,0)


/***********/
/*Procedury*/
/***********/

/*Procedury aktualizacji wierszy*/
create procedure upDostawcy(@nazw nvarchar(20),@bit BIT)
as
Update DostawcyP
Set Zajetosc = @bit
where DostawcyP.Imie_Nazwisko = @nazw
GO

create procedure upZamowienia(@id int,@ids int,@idp int,@idd int, @ilosc int, @koszt int,@bit BIT)
as
Update ZamowieniaP
Set Id_sklepu = @ids,Id_produktu=@idp,Id_dostawy=@idd,Ilosc=@ilosc,Koszt=@koszt,Zrealizowano=@bit 
where ZamowieniaP.Id_zamowienia=@id
GO

create procedure upProd(@cena int,@nazwa nvarchar(30),@idmag int)
as
Update ProduktyP
Set Cena = @cena, Id_magazynu = @idmag
where ProduktyP.Pelna_nazwa=@nazwa
GO

create procedure upSklep(@id int,@liczba int)
as
Update SklepyP
Set Liczba_produktow = @liczba
where SklepyP.Id_sklepu = @id
GO

create procedure upDostawy(@id int,@idd int)
as
Update DostawyP
Set Id_dostawcy = @idd
where DostawyP.Id_dostawy=@id
GO

/*Procedury wstawiania do wierszy*/
create procedure inWoj(@id nvarchar(3),@nazwa nvarchar(30))
as
insert into WojewodztwaP(Id_woj,NAZWA)
values(@id,@nazwa)
GO

create procedure inMiasta(@id nvarchar(3),@kodwoj nvarchar(3),@nazwa nvarchar(30))
as
insert into MiastaP(Id_miasta,KOD_woj,NAZWA)
values(@id,@kodwoj,@nazwa)
GO

create procedure inMagazyn(@id nvarchar(3),@liczba int)
as
insert into MagazynyP(Id_miasta,Liczba_produktow)
values(@id,@liczba)
GO

create procedure inSklep(@id nvarchar(3),@adres nvarchar(30))
as
insert into SklepyP(Id_miasta,Adres,Liczba_produktow)
values(@id,@adres,0)
GO

create procedure inDostawcy(@imie nvarchar(20),@bit BIT)
as
insert into DostawcyP(Imie_Nazwisko,Zajetosc)
values(@imie,@bit)
GO

create procedure inDostawy(@id int)
as
insert into DostawyP(Id_dostawcy)
values(@id)
GO

create procedure inProdukt(@id int,@nazwa nvarchar(30),@cena int)
as
insert into ProduktyP(Id_magazynu,Pelna_nazwa,Cena)
values(@id,@nazwa,@cena)
GO

create procedure inZamowienia(@ids int,@idp int,@idd int,@ilosc int)
as
insert into ZamowieniaP(Id_sklepu,Id_produktu,Id_dostawy,Ilosc,Zrealizowano)
values(@ids,@idp,@idd,@ilosc,0)
GO

/*Procedury dodawania do wielu tabel*/ 

/*Dodawanie nowego Zamówienia wi¹¿e siê z dodaniem nowej Dostawy i przypisaniem wolnego dostawcy.*/
create procedure ExtendedInTransaction(@ids int,@idp int,@ilosc int)
as
Declare @id int
declare @idd int
declare @cost int
set @id=(Select min(Id_dostawcy) from DostawcyP d where d.Zajetosc=0) 
insert into DostawyP(Id_dostawcy)
values(@id)
set @idd=(Select max(Id_dostawy) from DostawyP)
set @cost = @ilosc*(select p.Cena from ProduktyP p where p.Id_produktu=@idp)
insert into ZamowieniaP(Id_sklepu,Id_produktu,Id_dostawy,Ilosc,Koszt,Zrealizowano)
values(@ids,@idp,@idd,@ilosc,@cost,0)
Update DostawcyP set Zajetosc = 1 where Id_dostawcy=@id
GO

/*Dodanie zupe³nie nowego produktu wraz z dodaniem nowego magazynu do przechowywania.*/
create procedure ExtendedInProduct(@nazwa nvarchar(30),@cena int,@liczba int, @idm NVARCHAR(3))
as
declare @id int
insert into MagazynyP(Id_miasta,Liczba_produktow)
values(@idm,@liczba)
set @id = (select max(Id_magazynu) from MagazynyP )
insert into ProduktyP(Id_magazynu,Pelna_nazwa,Cena)
values(@id,@nazwa,@cena)
GO

/**********/
/*Triggery*/
/**********/

/*Triggery Insert*/
/*Gdy dodamy nowe zamówienie automatycznie wpisujemy jego koszt na podstawie iloœci zamówionego produktu.*/
Create Trigger CostTrigger on ZamowieniaP
for insert
as
DECLARE @id int
DECLARE @ilosc int
Declare @cost int
begin
SET @id = (select i.id_produktu from inserted i)
SET @ilosc = (select i.Ilosc from inserted i)
set @cost = (select p.Cena from ProduktyP p where p.id_produktu=@id)
Update ZamowieniaP Set koszt = @cost*@ilosc
where Id_zamowienia = (select i.Id_zamowienia from inserted i)
end
GO

/*Gdy dodajemy sklep dodawane jest zamówienie na produkty by nowopowsta³y punkt sprzeda¿y nie by³ pusty.*/
Create Trigger AddTransactionTrigger on SklepyP
for insert
as
DECLARE @ids int
DECLARE @idd int
Declare @idp int
begin
SET @ids = (select i.id_sklepu from inserted i)
set @idp = (Select max(Id_produktu) from ProduktyP)
insert into DostawyP(Id_dostawcy)
values(null)
set @idd=(Select max(Id_dostawy) from DostawyP)
insert into ZamowieniaP(Id_sklepu,Id_produktu,Id_dostawy,Ilosc,Zrealizowano)
values(@ids,@idp,@idd,50,0)
end
GO

/*Triggery Delete*/
/*Gdy usuwamy Produkt, opró¿niamy przypisane magazyny*/
Create Trigger DeleteProductTrigger on ProduktyP
for delete
as
declare @idmagazynu int
declare @idproduktu int
begin
set @idproduktu = (select i.Id_produktu from deleted i)
set @idmagazynu = (select max(i.Id_magazynu) from deleted i)
Update MagazynyP Set Liczba_produktow = 0
where Id_magazynu=@idmagazynu
end
GO

/*Gdy usuwamy zamówienie to usuwamy dostawê z magazynu i zwalniamy status dostawcy.*/
Create Trigger DeleteTransactionTrigger on ZamowieniaP
for delete
as
declare @iddostawy int
declare @iddostawcy int
begin
set @iddostawy = (select i.Id_dostawy from deleted i)
set @iddostawcy = (select d.Id_dostawcy from DostawyP d where d.Id_dostawy=@iddostawy)
Delete DostawyP where Id_dostawy =@iddostawy
Update DostawcyP set Zajetosc = 0 where Id_dostawcy=@iddostawcy
end
GO

/*Triggery Update*/ 
/*Aktualizacja Produktu zmienia automatycznie informacje w jego zamówieniach, dotyczy to ceny produktu a wiêc sumarycznego kosztu zamówienia.*/
Create Trigger UpdateProductTrigger on ProduktyP
for update
as
declare @idprod int
declare @cena int
IF UPDATE(Cena) 
begin
set @idprod = (select i.Id_produktu from deleted i)
set @cena = (select d.Cena from inserted d)
Update ZamowieniaP set Koszt = @cena* ZamowieniaP.Ilosc  
where Id_produktu=@idprod
end
GO

/*Aktualizacja Sklepu sprawdza czy wprowadzono poprawn¹ iloœæ produktów w sklepie po zrealizowanych dostawach, jeœli iloœci siê zgadzaj¹, zeruje zamówienie jako ¿e produkty zosta³y dostarczone.*/
Create Trigger UpdateShopTrigger on SklepyP
for update
as
if update(Liczba_produktow)
declare @idsklepu int
declare @ilosc int
declare @ilosc2 int
declare @sum int
begin
set @idsklepu = (select i.Id_sklepu from deleted i)
set @ilosc = (select d.Liczba_produktow from deleted d)
set @ilosc2 = (select d.Liczba_produktow from inserted d)
set @sum = (select SUM(Ilosc) from ZamowieniaP z where z.Id_sklepu=@idsklepu and z.Zrealizowano=1)
if @ilosc2 != @sum +@ilosc
begin
Print 'Niepoprawna ilosc towaru, wprowadz: '+convert(varchar,@sum+@ilosc)
Rollback Tran
end
else
begin
Update ZamowieniaP Set Ilosc=0 where Id_sklepu=@idsklepu
end
end
GO

/*Aktualizacja Dostawy sprawdza dostêpnoœæ danego dostawcy do zrealizowania danej dostawy.*/
Create Trigger UpdateDeliveryTrigger on DostawyP
for update
as
if update(Id_dostawcy)
declare @idd int
declare @znak BIT
begin
set @idd = (select i.Id_dostawcy from inserted i)
set @znak = (select d.Zajetosc from DostawcyP d where Id_dostawcy =@idd)
if @znak != 0
begin
Print 'Dostawca zajêty, proszê wybraæ innego pracownika'
Rollback Tran
end
else
begin
Update DostawcyP set Zajetosc =1 where Id_dostawcy=@idd
end
end
GO


/*Aktualizacja Zamówienia sprawdza czy zmieniono status realizacji na wykonano (BIT ustawiony na 1), jeœli tak, usuwa dostawê i zwalnia status dostawcy.*/
Create Trigger UpdateTransactionTrigger on ZamowieniaP
for update
as
declare @idd int
declare @idzam int
declare @znak BIT
declare @iddostaw int
if update(Zrealizowano) 
begin
set @znak = (select i.zrealizowano from inserted i)
set @idzam = (select d.Id_zamowienia from deleted d)
set @idd = (select d.Id_dostawy from ZamowieniaP d where d.Id_zamowienia=@idzam)
set @iddostaw = (select f.Id_dostawcy from DostawyP f where f.Id_dostawy=@idd)
if @znak = 1
begin
Update ZamowieniaP set Id_dostawy=null where Id_dostawy=@idd
Delete from DostawyP where Id_dostawy=@idd
Update DostawcyP Set Zajetosc=0 where Id_dostawcy=@iddostaw
end
end
GO



/*****************************************/
/*Przyk³adowe wywo³ania procedur wstawiania do wielu tabel z select*/
/*****************************************/
/*Dodawanie nowego Zamówienia wi¹¿e siê z dodaniem nowej Dostawy i przypisaniem wolnego dostawcy.*/
EXEC ExtendedInTransaction @ids=1 ,@idp= 1,@ilosc=10
Select * from ZamowieniaP z where z.Id_sklepu = 1
Select * from DostawyP d where d.Id_dostawcy is not null 

/*Dodanie zupe³nie nowego produktu wraz z dodaniem nowego magazynu do przechowywania.*/
EXEC ExtendedInProduct @nazwa='LG TY' ,@cena=689,@liczba=30, @idm='GDA'
select * from MagazynyP m where m.id_miasta like 'GDA'
select * from ProduktyP p where p.Pelna_nazwa like 'LG TY'

/******************************************/
/*Przyk³adowe wywo³ania triggerów z select*/
/******************************************/

/*Gdy dodamy nowe zamówienie automatycznie wpisujemy jego koszt na podstawie iloœci  zamówionego produktu.*/	
exec InZamowienia @ids=1,@idp=2,@idd=1,@ilosc=10
Select * from ZamowieniaP z where z.id_sklepu=1 and z.id_produktu=2

/*Gdy dodajemy sklep dodawane jest zamówienie na produkty by nowopowsta³y punkt sprzeda¿y nie by³ pusty.*/
exec inSklep @id='WAW' ,@adres='Waryñskiego 179'
Select * from ZamowieniaP z
	join SklepyP s on(s.Id_sklepu=z.Id_sklepu)
	where s.Adres like 'Waryñskiego 179'

/*Gdy usuwamy Produkt, opró¿niamy przypisane magazyny*/
Delete From ProduktyP where Pelna_nazwa ='Pralka JH-300 Philips'
select* from ProduktyP  
Select* from MagazynyP

/*Gdy usuwamy zamówienie to usuwamy dostawê z magazynu i zwalniamy status dostawcy.*/
Delete From ZamowieniaP where Id_dostawy=6
Select * from ZamowieniaP 
select* from DostawyP 
Select* from DostawcyP


/*Aktualizacja Produktu zmienia automatycznie informacje w jego zamówieniach, dotyczy to ceny produktu a wiêc sumarycznego kosztu zamówienia.*/
Update ProduktyP Set Cena=100 where Id_produktu=1
Select* from ProduktyP
Select * from ZamowieniaP z where z.Id_produktu =1

/*Aktualizacja Sklepu sprawdza czy wprowadzono poprawn¹ iloœæ produktów w sklepie po zrealizowanych dostawach, jeœli iloœci siê zgadzaj¹, zeruje zamówienie jako ¿e produkty zosta³y dostarczone.*/
Update ZamowieniaP set Zrealizowano=1 where Id_sklepu=4
Update SklepyP set Liczba_produktow =1150 where Id_sklepu=4
Select * from SklepyP

/*Aktualizacja Dostawy sprawdza dostêpnoœæ danego dostawcy do zrealizowania danej dostawy.*/
Update DostawyP set Id_dostawcy = 4 where Id_dostawy = 3
Select * From DostawcyP
Select * from DostawyP

/*Aktualizacja Zamówienia sprawdza czy zmieniono status realizacji na wykonano (BIT ustawiony na 1), jeœli tak, usuwa dostawê i zwalnia status dostawcy.*/
Update ZamowieniaP set Zrealizowano=1 where Id_dostawy=1
Select * From DostawcyP
Select * from DostawyP