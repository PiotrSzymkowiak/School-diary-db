--tworzenie tabel
CREATE TABLE Nauczyciel
(
id_nauczyciela      	numeric(8,0) IDENTITY(1,1) PRIMARY KEY,
imie                		varchar(20) NOT NULL,
nazwisko           	 	varchar(60) NOT NULL,
adres_zamieszkania  numeric(8,0) NOT NULL,
PESEL               		numeric(11,0) NOT NULL,
stanowisko          	varchar(50),
zarobki             		numeric(10,0),
staz                		numeric(5,0),
numer_umowy         varchar(12)

);
GO

CREATE TABLE Komentarz
(
id_komentarza       numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
tytul               	varchar(30) NOT NULL,
komentarz           varchar(255) NOT NULL,
id_ucznia           numeric(8,0) NOT NULL,
id_nauczyciela      numeric(8,0) NOT NULL,
data                date
);
GO

CREATE TABLE Ocena
(
id_oceny            numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
tytul               varchar(30) NOT NULL,
ocena               numeric(1,0) NOT NULL,
modyfikator         varchar(1),
Waga                numeric(1,0) NOT NULL,
id_ucznia           numeric(8,0) NOT NULL,
id_nauczyciela      numeric(8,0) NOT NULL,
id_lekcji           numeric(8,0) NOT NULL, 
CONSTRAINT ocena_check_less_6 CHECK (ocena > 0 AND ocena <= 6)
);
GO

CREATE TABLE Klasa
(
id_klasy            numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
stopien             numeric(1,0) NOT NULL,
numer               numeric(1,0) NOT NULL,
id_nauczyciela      numeric(8,0) NOT NULL,
specjalizacja       varchar(30) NOT NULL
);
GO

CREATE TABLE Lekcja
(
id_lekcji           numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
tytul               varchar(30) NOT NULL,
id_nauczyciela      numeric(8,0) NOT NULL,
id_klasy            numeric(8,0) NOT NULL,
data                date NOT NULL,
sala                varchar(5) NOT NULL,
uwagi               varchar(255)
);
GO

CREATE TABLE Plan_lekcji
(
id_lekcji           numeric(8,0) NOT NULL,
id_ucznia           numeric(8,0) NOT NULL,
frekwencja          numeric(1,0) NOT NULL,
);
GO

CREATE TABLE Uczen
(
id_ucznia           numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
imie                varchar(20) NOT NULL,
nazwisko            varchar(60) NOT NULL,
adres_zamieszkania  numeric(8,0) NOT NULL,
PESEL               numeric(11,0) NOT NULL,
id_klasy            numeric(8,0) NOT NULL
);
GO

CREATE TABLE Opiekun
(
id_opiekuna         numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
imie                varchar(20) NOT NULL,
nazwisko            varchar(60) NOT NULL, 
PESEL               numeric(11,0) NOT NULL,
adres_zamieszkania  numeric(8,0) NOT NULL,
);
GO

CREATE TABLE uczen_opiekun
( 
id_ucznia           numeric(8,0) NOT NULL,
id_opiekuna         numeric(8,0) NOT NULL
);
GO

CREATE TABLE adres_zamieszkania
(
adres_zamieszkania  numeric(8,0) IDENTITY(1,1)  PRIMARY KEY,
kod_pocz            varchar(6) NOT NULL,
Miasto              varchar(30) NOT NULL,
Ulica               varchar(30) NOT NULL,
nr_bud              varchar(5) NOT NULL,
nr_miesz            varchar(5)
);
GO

/****** Object:  Table [dbo].[ZAKODOWANE]    Script Date: 09.01.2017 11:36:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE Nauczyciel ADD CONSTRAINT Nauczyciel_adres_zamieszkania_FK
FOREIGN KEY (adres_zamieszkania) REFERENCES adres_zamieszkania(adres_zamieszkania)
GO

ALTER TABLE Komentarz ADD CONSTRAINT Komentarz_id_nauczyciela_FK
FOREIGN KEY (id_nauczyciela) REFERENCES Nauczyciel(id_nauczyciela)
GO

ALTER TABLE Komentarz ADD CONSTRAINT Komentarz_id_ucznia_FK
FOREIGN KEY (id_ucznia) REFERENCES Uczen(id_ucznia)
GO

ALTER TABLE Ocena ADD CONSTRAINT Ocena_id_ucznia_FK
FOREIGN KEY (id_ucznia) REFERENCES Uczen(id_ucznia)
GO

ALTER TABLE Ocena ADD CONSTRAINT Ocena_id_nauczyciela_FK
FOREIGN KEY (id_nauczyciela) REFERENCES Nauczyciel(id_nauczyciela)
GO

ALTER TABLE Ocena ADD CONSTRAINT Ocena_id_lekcji_FK
FOREIGN KEY (id_lekcji) REFERENCES Lekcja(id_lekcji)
GO

ALTER TABLE Klasa ADD CONSTRAINT Klasa_id_nauczyciela_FK
FOREIGN KEY (id_nauczyciela) REFERENCES Nauczyciel(id_nauczyciela)
GO

ALTER TABLE Lekcja ADD CONSTRAINT Lekcja_id_nauczyciela_FK
FOREIGN KEY (id_nauczyciela) REFERENCES Nauczyciel(id_nauczyciela)
GO

ALTER TABLE Lekcja ADD CONSTRAINT Lekcja_id_klasy_FK
FOREIGN KEY (id_klasy) REFERENCES Klasa(id_klasy)
GO

ALTER TABLE Plan_lekcji ADD CONSTRAINT Plan_lekcji_id_lekcji_FK
FOREIGN KEY (id_lekcji) REFERENCES Lekcja(id_lekcji)
GO

ALTER TABLE Plan_lekcji ADD CONSTRAINT Plan_lekcji_id_ucznia_FK
FOREIGN KEY (id_ucznia) REFERENCES Uczen(id_ucznia)
GO

ALTER TABLE Uczen ADD CONSTRAINT Uczen_adres_zamieszkania_FK
FOREIGN KEY (adres_zamieszkania) REFERENCES adres_zamieszkania(adres_zamieszkania)
GO

ALTER TABLE Uczen ADD CONSTRAINT Uczen_id_klasy_FK
FOREIGN KEY (id_klasy) REFERENCES Klasa(id_klasy)
GO

ALTER TABLE Opiekun ADD CONSTRAINT Opiekun_adres_zamieszkania_FK
FOREIGN KEY (adres_zamieszkania) REFERENCES adres_zamieszkania(adres_zamieszkania)
GO

ALTER TABLE uczen_opiekun ADD CONSTRAINT uczen_opiekun_id_ucznia_FK
FOREIGN KEY (id_ucznia) REFERENCES Uczen(id_ucznia)
GO

ALTER TABLE uczen_opiekun ADD CONSTRAINT uczen_opiekun_id_opiekuna_FK
FOREIGN KEY (id_opiekuna) REFERENCES Opiekun(id_opiekuna)
GO

-- widoki
CREATE VIEW widok_listy_klas AS
SELECT id_klasy as "Identyfikator_klasy", stopien as "Stopień_klasy", numer as "Numer_klasy", specjalizacja as "Specjalizacja_klasy", imie as "Imię_wychowawcy", nazwisko as "Nazwisko_wychowawcy"
FROM Klasa JOIN Nauczyciel ON Klasa.id_nauczyciela=Nauczyciel.id_nauczyciela;
GO

CREATE VIEW widok_listy_uczniow_klas AS
SELECT imie as "Imię_ucznia", nazwisko as "Nazwisko_Ucznia", PESEL, Uczen.id_klasy as "Identyfikator_klasy", stopien as "Stopien_klasy", numer as "Numer_Klasy", specjalizacja as "Specjalizacja_klasy"
FROM Uczen JOIN Klasa on Uczen.id_klasy = Klasa.id_klasy;
GO

CREATE VIEW widok_ocen_ucznia AS
SELECT Uczen.id_ucznia as "Identyfikator_Ucznia", imie as "Imię_ucznia", nazwisko as "Nazwisko_Ucznia", PESEL, Ocena.tytul as "Tytuł_oceny", ocena, Waga, Lekcja.tytul as "Lekcja"
FROM Uczen JOIN Ocena on Uczen.id_ucznia = Ocena.id_ucznia JOIN  Lekcja on Lekcja.id_lekcji = Ocena.id_lekcji;
GO

CREATE VIEW widok_lekcji_klasy AS
SELECT Klasa.id_klasy as "Identyfikator_klasy", stopien as "Stopień_klasy", numer as "Numer_klasy", specjalizacja as "Specjalizacja_klasy",
imie as "Imię_nauczyciela", nazwisko as "Nazwisko_nauczyciela",
tytul as "Lekcja", data as "Data_lekcji", sala as "Sala"
FROM Klasa JOIN Lekcja on Klasa.id_klasy = Lekcja.id_klasy JOIN  Nauczyciel on Lekcja.id_nauczyciela = Nauczyciel.id_nauczyciela;
GO

CREATE VIEW widok_listy_nauczycieli AS
SELECT Nauczyciel.id_nauczyciela as "Identyfikator_nauczyciela", imie as "Imię_nauczyciela", nazwisko as "Nazwisko_nauczyciela", PESEL, stanowisko, zarobki, staz, numer_umowy,
id_klasy as "Wychowawca_klasy_o_identyfikatorze: "
FROM Nauczyciel LEFT JOIN Klasa ON Nauczyciel.id_nauczyciela=Klasa.id_nauczyciela;
GO

--indeksy
CREATE INDEX PESEL ON Uczen (imie, nazwisko, PESEL);
GO

CREATE INDEX NAZWISKO ON Uczen (imie, nazwisko, PESEL);
GO

CREATE INDEX NAZWISKO ON Opiekun (imie, nazwisko, PESEL);
GO


--dane testowe
-- l. nauczycieli: 10
-- l. klas: 3
-- l. uczniow na klase: 1. 5, 2. 10, 3. 7
-- l. lekcji: 9
-- l. opiekunow: 22
-- l. ocen na ucznia: 1 --> 22
-- l. adresow zamieszkania:  32

INSERT INTO adres_zamieszkania (kod_pocz, Miasto, Ulica, nr_bud) VALUES
 ('50-355', 'Wrocław', 'Grunwaldzka', '23'),
 ('50-305', 'Wrocław', 'Brodzka', '54'),
 ('51-356', 'Wrocław', 'Sienkiewicza', '12'),
 ('53-474', 'Wrocław', 'Pl. Jana Pawła II', '13'),
 ('54-335', 'Wrocław', 'Pl. Grunwaldzki', '6a'),
 ('51-334', 'Wrocław', 'Nowowiejska', '32'),
 ('53-435', 'Wrocław', 'Trzebnicka', '44'),
 ('52-311', 'Wrocław', 'Żmigrodzka', '1'),
 ('50-453', 'Wrocław', 'Obornicka', '43'),
 ('50-335', 'Wrocław', 'Grunwaldzka', '7'),
 ('51-385', 'Wrocław', 'Pl. Grunwaldzki', '15'),
 ('50-321', 'Wrocław', 'Nowowiejska', '16'),
 ('52-463', 'Wrocław', 'Świdnicka', '75'),
 ('52-358', 'Wrocław', 'Ruska', '33'),
 ('50-355', 'Wrocław', 'Legnicka', '9'),
 ('53-405', 'Wrocław', 'Kolista', '2'),
 ('51-321', 'Wrocław', 'Niedźwiedzia', '42'),
 ('50-345', 'Wrocław', 'Pl. Dominikański', '11'),
 ('55-373', 'Wrocław', 'Wyszyńskiego', '7'),
 ('52-352', 'Wrocław', 'Szczytnicka', '58'),
 ('50-455', 'Wrocław', 'Katedralna', '89'),
 ('50-355', 'Wrocław', 'Pl. Bema', '22'),
 ('50-345', 'Wrocław', 'Rydygiera', '28'),
 ('53-456', 'Wrocław', 'Nożownicza', '36'),
 ('50-355', 'Wrocław', 'Krupnicza', '57'),
 ('51-345', 'Wrocław', 'Szewska', '39'),
 ('50-355', 'Wrocław', 'Wojanowska', '41'),
 ('50-456', 'Wrocław', 'Arbuzowa', '27'),
 ('50-378', 'Wrocław', 'Kasprowicza', '83'),
 ('52-455', 'Wrocław', 'Sienkiewicza', '3'),
 ('50-334', 'Wrocław', 'Broniewskiego', '67'),
 ('53-455', 'Wrocław', 'Kleczkowska', '5')
 GO

 INSERT INTO Nauczyciel (imie, nazwisko, adres_zamieszkania, PESEL) VALUES
('Piotr', 'Wójcik', '1', 73072305432),
('Mikołaj', 'Świątek', '2', 77120607431),
('Anna', 'Mazur', '3', 81030316742),
('Wiktoria', 'Wawrzyniak', '4', 75051514565),
('Kazimiera', 'Paździor', '5', 56060713621),
('Paweł', 'Janas', '6', 83082703146),
('Adam', 'Duda', '7', 76091107623),
('Beata', 'Wesołowska', '8', 79010101967)
GO

INSERT INTO Klasa (stopien, numer, id_nauczyciela, specjalizacja) VALUES
('1', '1', '5', 'Humanistyczna'),
('2', '1', '2', 'Matematyczna'),
('3', '1', '7', 'Lingwistyczna')
GO

INSERT INTO Uczen (imie, nazwisko, adres_zamieszkania, PESEL, id_klasy) VALUES
('Artur', 'Nowak', '9', 20010104576, '1'),
('Magłorzata', 'Kowalska', '10', 20081119745, '1'),
('Basia', 'Paluszek', '11', 20110512376, '1'),
('Monika', 'Owczarek', '12', 20010911325, '1'),
('Adrian', 'Kalisz', '13', 20032705652, '1'),
('Arkadiusz', 'Szymański', '14', 99051207634, '2'),
('Adam', 'Dziuba', '15', 99072207643, '2'),
('Amanda', 'Jednacz', '16', 99042118745, '2'),
('Karol', 'Milik', '17', 99091107624, '2'),
('Dawid', 'Rzeźniczak', '18', 99060608734, '2'),
('Piotr', 'Skorupski', '19', 99111106523, '2'),
('Agnieszka', 'Kordiak', '20', 99012915423, '2'),
('Ola', 'Błaszczak', '21', 99022514622, '2'),
('Wojtek', 'Lewandowski', '22', 99121202456, '2'),
('Mariusz', 'Wasilewski', '23', 99041106587, '2'),
('Bartosz', 'Sobala', '24', 98010805687, '3'),
('Anita', 'Tyrcz', '25', 98022619834, '3'),
('Wiktoria', 'Tylus', '26', 98050811265, '3'),
('Weronika', 'Gryniewicz', '27', 98081412376, '3'),
('Klaudia', 'Karczmarczyk', '28', 98092711276, '3'),
('Damian', 'Ruszkiewicz', '29', 98112504863, '3'),
('Mateusz', 'Kucharczak', '30', 98030307634, '3')
GO

INSERT INTO Opiekun (imie, nazwisko, adres_zamieszkania, PESEL) VALUES
('Paweł', 'Nowak', '9', 76010703475),
('Anna', 'Kowalska', '10', 77021113465),
('Ewa', 'Paluszek', '11', 73050513254),
('Gabriela', 'Owczarek', '12', 81050213498),
('Mirek', 'Kalisz', '13', 68032004875),
('Jan', 'Szymański', '14', 69021201653),
('Leszek', 'Dziuba', '15', 70072208361),
('Kamil', 'Jednacz', '16', 76052719573),
('Robert', 'Milik', '17', 79041201542),
('Aleksander', 'Rzeźniczak', '18', 73050508674),
('Ryszard', 'Skorupski', '19', 72030303893),
('Grażyna', 'Kordiak', '20', 71031314565),
('Maria', 'Błaszczak', '21', 64021717634),
('Arkadiusz', 'Lewandowski', '22', 69111408723),
('Wojciech', 'Wasilewski', '23', 73061604763),
('Marek', 'Sobala', '24', 71070806745),
('Piotr', 'Tyrcz', '25', 77032312658),
('Adam', 'Tylus', '26', 74071615643),
('Wioletta', 'Gryniewicz', '27', 67051918789),
('Kamila', 'Karczmarczyk', '28', 78021213443),
('Czesław', 'Ruszkiewicz', '29', 82112106775),
('Szymon', 'Kucharczak', '30', 81050202244)
GO

INSERT INTO uczen_opiekun (id_ucznia, id_opiekuna) VALUES
('1','1'), ('2','2'), ('3','3'), ('4','4'), ('5','5'), ('6','6'), ('7','7'), ('8','8'), ('9','9'),
('10','10'), ('11','11'), ('12','12'), ('13','13'), ('14','14'), ('15','15'), ('16','16'), ('17','17'),
('18','18'), ('19','19'), ('20','20'), ('21','21'), ('22','22')
GO

INSERT INTO Lekcja (tytul, id_nauczyciela, id_klasy, data, sala) VALUES
('j.polski', '5', '1', '2016-11-29', 7),
('matematyka', '6', '1', '2016-12-01', 1),
('j.angielski', '1', '1', '2016-11-30', 4),
('j.polski', '3', '2', '2016-12-01', 8),
('matematyka', '2', '2', '2016-11-29', 2),
('angielski', '7', '2', '2016-11-30', 5),
('j.polski', '8', '3', '2016-11-30', 9),
('matematyka', '4', '3', '2016-12-01', 3),
('angielski', '7', '3', '2016-11-29', 6)
GO

INSERT INTO Ocena (tytul, ocena, Waga, id_ucznia, id_nauczyciela, id_lekcji) VALUES
('Odpowiedź ustna', 5, 1, '1', '5', '1'),
('Odpowiedź ustna', 3, 1, '2', '5', '1'),
('Odpowiedź ustna', 2, 1, '3', '5', '1'),
('Odpowiedź ustna', 4, 1, '4', '5', '1'),
('Odpowiedź ustna', 1, 1, '5', '5', '1'),
('Sprawdzian', 4, 2, '6', '2', '5'),
('Sprawdzian', 3, 2, '7', '2', '5'),
('Sprawdzian', 5, 2, '8', '2', '5'),
('Sprawdzian', 5, 2, '9', '2', '5'),
('Sprawdzian', 2, 2, '10', '2', '5'),
('Sprawdzian', 3, 2, '11', '2', '5'),
('Sprawdzian', 1, 2, '12', '2', '5'),
('Sprawdzian', 5, 2, '13', '2', '5'),
('Sprawdzian', 4, 2, '14', '2', '5'),
('Sprawdzian', 4, 2, '15', '2', '5'),
('Kartkówka', 3, 1, '16', '7', '9'),
('Kartkówka', 5, 1, '17', '7', '9'),
('Kartkówka', 4, 1, '18', '7', '9'),
('Kartkówka', 5, 1, '19', '7', '9'),
('Kartkówka', 3, 1, '20', '7', '9'),
('Kartkówka', 2, 1, '21', '7', '9'),
('Kartkówka', 4, 1, '22', '7', '9'),
('Brak zadania', 1, 1, '5', '6', '2')
GO

INSERT INTO Komentarz (tytul, komentarz, id_ucznia, id_nauczyciela) VALUES
('Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', '1', '5'),
('Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', '13', '2'),
('Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', '17', '7'),
('Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', '19', '7'),
('Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', '8', '2'),
('Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', '9', '2'),
('Ostrzeżenie', 'Uczeń/Uczennica dostał/a ocenę niedsotateczną!', '12', '2'),
('Ostrzeżenie', 'Uczeń/Uczennica dostał/a ocenę niedsotateczną!', '5', '6'),
('Ostrzeżenie', 'Uczeń/Uczennica dostał/a ocenę niedsotateczną!', '5', '5')
GO

INSERT INTO Plan_lekcji (id_lekcji, id_ucznia, frekwencja) VALUES
('1','1', 1),
('1','2', 1),
('1','3', 1),
('1','4', 1),
('1','5', 1),
('5','6', 1),
('5','7', 1),
('5','8', 1),
('5','9', 1),
('5','10',1),
('5','11',1),
('5','12',1),
('5','13',1),
('5','14',1),
('5','15',1),
('9','16',1),
('9','17',1),
('9','18',1),
('9','19',1),
('9','20',1),
('9','21',1),
('9','22',1),
('2','1', 1),
('2','2', 1),
('2','3', 1),
('2','4', 0),
('2','5', 1),
('4','6', 1),
('4','7', 1),
('4','8', 1),
('4','9', 1),
('4','10',1),
('4','11',0),
('4','12',1),
('4','13',1),
('4','14',0),
('4','15',1),
('7','16',1),
('7','17',1),
('7','18',1),
('7','19',1),
('7','20',0),
('7','21',1),
('7','22',1),
('3','1', 1),
('3','2', 1),
('3','3', 1),
('3','4', 1),
('3','5', 1),
('6','6', 0),
('6','7', 1),
('6','8', 0),
('6','9', 1),
('6','10',1),
('6','11',1),
('6','12',1),
('6','13',1),
('6','14',1),
('6','15',1),
('8','16',1),
('8','17',1),
('8','18',1),
('8','19',0),
('8','20',0),
('8','21',1),
('8','22',1)
GO

--procedury
CREATE PROC spWyswietlKlase  
@id_klasy numeric(8,0)  
AS  
BEGIN  
SELECT *  FROM widok_listy_uczniow_klas  
WHERE Identyfikator_klasy = @id_klasy  
END
GO

CREATE PROC spWyswietlOcenyUcznia  
@id_ucznia numeric(8,0)  
AS  
BEGIN  
SELECT *  FROM widok_ocen_ucznia  
WHERE Identyfikator_Ucznia = @id_ucznia  
END
GO

CREATE PROC spWyswietlLekcjeKlasy
@id_klasy	numeric(8,0)
AS
BEGIN
SELECT * FROM widok_lekcji_klasy
WHERE Identyfikator_klasy = @id_klasy
END
GO

CREATE PROC spWyswietlInfoKlasy
@id_klasy numeric(8,0)
AS
BEGIN
SELECT * FROM widok_listy_klas
WHERE Identyfikator_klasy = @id_klasy
END
GO

CREATE PROC spWyswietlInfoNauczyciela
@id_nauczyciela numeric(8,0)
AS
BEGIN
SELECT * FROM widok_listy_nauczycieli
WHERE Identyfikator_nauczyciela = @id_nauczyciela
END
GO

-- SP_inserty
CREATE PROC spDodajNauczyciela
@imie varchar(20), @nazwisko varchar(60), @adres numeric(8,0), @PESEL numeric(11,0),
@stanowisko varchar(50) = null, @zarobki numeric(10,0) = null, @staz numeric(5,0) = null, @numer_umowy varchar(12) = null
AS
BEGIN
INSERT INTO Nauczyciel (imie, nazwisko, adres_zamieszkania, PESEL, stanowisko, zarobki, staz, numer_umowy) VALUES
(@imie, @nazwisko, @adres, @PESEL, @stanowisko, @zarobki, @staz, @numer_umowy)
END
GO

CREATE PROC spDodajAdres
@kod_pocz varchar(6), @miasto varchar(30), @ulica varchar(30), @nr_bud  varchar(5), @nr_miesz varchar(5) = null
AS
BEGIN
INSERT INTO adres_zamieszkania (kod_pocz, Miasto, Ulica, nr_bud, nr_miesz) VALUES
(@kod_pocz, @miasto, @ulica, @nr_bud, @nr_miesz)
END
GO

CREATE PROC spDodajKlase
@stopien numeric(1,0), @numer numeric (1,0), @id_nauczyciela numeric(8,0), @specjalizacja varchar(30)
AS
BEGIN
INSERT INTO Klasa (stopien, numer, id_nauczyciela, specjalizacja) VALUES
(@stopien, @numer, @id_nauczyciela, @specjalizacja)
END
GO

CREATE PROC spDodajUcznia
@imie varchar(20), @nazwisko varchar(60), @adres numeric(8,0), @PESEL numeric(11,0), @id_klasy numeric(8,0)
AS
BEGIN
INSERT INTO Uczen (imie, nazwisko, adres_zamieszkania, PESEL, id_klasy) VALUES
(@imie, @nazwisko, @adres, @PESEL, @id_klasy)
END
GO

CREATE PROC spDodajOpiekuna
@imie varchar(20), @nazwisko varchar(60), @adres numeric(8,0), @PESEL numeric(11,0)
AS
BEGIN
INSERT INTO Opiekun (imie, nazwisko, adres_zamieszkania, PESEL) VALUES
(@imie, @nazwisko, @adres, @PESEL)
END
GO

CREATE PROC spDodajOcene
@tytul varchar(30), @ocena numeric(1,0), @modyfikator varchar(1) = null, @waga numeric(1,0),
@id_ucznia numeric(8,0), @id_nauczyciela numeric(8,0), @id_lekcji numeric(8,0)
AS
BEGIN
INSERT INTO Ocena (tytul, ocena, Waga, id_ucznia, id_nauczyciela, id_lekcji, modyfikator) VALUES
(@tytul, @ocena, @waga, @id_ucznia, @id_nauczyciela, @id_lekcji, @modyfikator)
END
GO

CREATE PROC spDodajRelacjeUczen_Opiekun
@id_ucznia numeric(8,0), @id_opiekuna numeric(8,0)
AS
BEGIN
INSERT INTO uczen_opiekun (id_ucznia, id_opiekuna) VALUES
(@id_ucznia, @id_opiekuna)
END
GO

CREATE PROC spDodajLekcje
@tytul varchar(30), @id_nauczyciela numeric(8,0), @id_klasy numeric(8,0),
@data date, @sala varchar(5) , @uwagi varchar(255) = null
AS
BEGIN
INSERT INTO Lekcja (tytul, id_nauczyciela, id_klasy, data, sala, uwagi) VALUES
(@tytul, @id_nauczyciela, @id_klasy, @data, @sala , @uwagi)
END
GO

CREATE PROC spDodajKomentarz
@tytul varchar(30), @komentarz varchar(255), @id_ucznia numeric(8,0),
@id_nauczyciela numeric(8,0), @data date = null
AS
BEGIN
INSERT INTO Komentarz (tytul, komentarz, id_ucznia, id_nauczyciela, data) VALUES
(@tytul, @komentarz, @id_ucznia, @id_nauczyciela, @data)
END
GO

CREATE PROC spDodajFrekwencje
@id_lekcji numeric(8,0), @id_ucznia numeric(8,0), @frekwencja numeric(1,0)
AS
BEGIN
INSERT INTO Plan_lekcji (id_lekcji, id_ucznia, frekwencja) VALUES
(@id_lekcji, @id_ucznia, @frekwencja)
END
GO

-- sp_update
CREATE PROC spAktualizujNauczyciela
@id_nauczyciela numeric(8,0), @imie varchar(20) = null, @nazwisko varchar(60) = null,
@adres numeric(8,0)= null, @PESEL numeric(11,0) = null, @stanowisko varchar(50) = null,
 @zarobki numeric(10,0) = null, @staz numeric(5,0) = null, @numer_umowy varchar(12) = null
AS
BEGIN
UPDATE Nauczyciel
SET imie = ISNULL(@imie, imie), nazwisko = ISNULL(@nazwisko, nazwisko),
	adres_zamieszkania = ISNULL(@adres, adres_zamieszkania), PESEL = ISNULL(@PESEL, PESEL),
	stanowisko = ISNULL(@stanowisko, stanowisko), zarobki = ISNULL(@zarobki, zarobki),
	staz = ISNULL(@staz, staz), numer_umowy = ISNULL(@numer_umowy, numer_umowy)
WHERE id_nauczyciela = @id_nauczyciela
END
GO

CREATE PROC spAktualizujAdres
@adres numeric(8,0), @kod_pocz varchar(6) = null, @miasto varchar(30) = null, @ulica varchar(30) = null,
 @nr_bud  varchar(5) = null, @nr_miesz varchar(5) = null
AS
BEGIN
UPDATE adres_zamieszkania
SET kod_pocz = ISNULL(@kod_pocz, kod_pocz), Miasto = ISNULL(@miasto, Miasto),
	Ulica = ISNULL(@ulica, Ulica), nr_bud = ISNULL(@nr_bud, nr_bud), nr_miesz = ISNULL(@nr_miesz, nr_miesz)
WHERE adres_zamieszkania = @adres
END
GO

CREATE PROC spAktualizujKlase
@id_klasy numeric(8,0), @stopien numeric(1,0) = null, @numer numeric (1,0) = null,
@id_nauczyciela numeric(8,0) = null, @specjalizacja varchar(30) = null
AS
BEGIN
UPDATE Klasa
SET stopien = ISNULL(@stopien, stopien), numer = ISNULL(@numer, numer),
	id_nauczyciela = ISNULL(@id_nauczyciela, id_nauczyciela), specjalizacja = ISNULL(@specjalizacja, specjalizacja)
WHERE id_klasy = @id_klasy
END
GO

CREATE PROC spAktualizujUcznia
@id_ucznia numeric(8,0), @imie varchar(20) = null, @nazwisko varchar(60) = null,
@adres numeric(8,0)= null, @PESEL numeric(11,0) = null, @id_klasy numeric(8,0) = null
AS
BEGIN
UPDATE Uczen
SET imie = ISNULL(@imie, imie), nazwisko = ISNULL(@nazwisko, nazwisko),
	adres_zamieszkania = ISNULL(@adres, adres_zamieszkania), PESEL = ISNULL(@PESEL, PESEL),
	id_klasy = ISNULL(@id_klasy, id_klasy)
	
WHERE id_ucznia = @id_ucznia
END
GO

CREATE PROC spAktualizujOpiekuna
@id_opiekuna numeric(8,0), @imie varchar(20) = null, @nazwisko varchar(60) = null,
@adres numeric(8,0)= null, @PESEL numeric(11,0) = null
AS
BEGIN
UPDATE Opiekun
SET imie = ISNULL(@imie, imie), nazwisko = ISNULL(@nazwisko, nazwisko),
	adres_zamieszkania = ISNULL(@adres, adres_zamieszkania), PESEL = ISNULL(@PESEL, PESEL)		
WHERE id_opiekuna = @id_opiekuna
END
GO

CREATE PROC spAktualizujOcene
@id_oceny numeric(8,0), @tytul varchar(30) = null, @ocena numeric(1,0) = null,
@modyfikator varchar(1) = null, @waga numeric(1,0) = null,
@id_ucznia numeric(8,0) = null, @id_nauczyciela numeric(8,0) = null, @id_lekcji numeric(8,0) = null
AS
BEGIN
UPDATE Ocena
SET tytul = ISNULL(@tytul, tytul), ocena = ISNULL(@ocena, ocena),
	modyfikator = ISNULL(@modyfikator, modyfikator), Waga = ISNULL(@waga, Waga),
	id_ucznia = ISNULL(@id_ucznia, id_ucznia), id_nauczyciela = ISNULL(@id_nauczyciela, id_nauczyciela),
	id_lekcji = ISNULL(@id_lekcji, id_lekcji)
WHERE id_oceny = @id_oceny
END
GO

CREATE PROC spAktualizujLekcje
@id_lekcji numeric(8,0), @tytul varchar(30) = null, @id_nauczyciela numeric(8,0) = null, @id_klasy numeric(8,0) = null,
@data date = null, @sala varchar(5) = null, @uwagi varchar(255) = null
AS
BEGIN
UPDATE Lekcja
SET tytul = ISNULL(@tytul, tytul), id_nauczyciela = ISNULL(@id_nauczyciela, id_nauczyciela),
	id_klasy = ISNULL(@id_klasy, id_klasy), data = ISNULL(@data, data),
	sala = ISNULL(@sala, sala), uwagi = ISNULL(@uwagi, uwagi)
WHERE id_lekcji = @id_lekcji
END
GO

CREATE PROC spAktualizujKomentarz
@id_komentarza numeric(8,0), @tytul varchar(30) = null, @komentarz varchar(255) = null, @id_ucznia numeric(8,0) = null,
@id_nauczyciela numeric(8,0) = null, @data date = null
AS
BEGIN
UPDATE Komentarz
SET tytul = ISNULL(@tytul, tytul), komentarz = ISNULL(@komentarz, komentarz),
id_ucznia = ISNULL(@id_ucznia, id_ucznia), id_nauczyciela = ISNULL(@id_nauczyciela, id_nauczyciela),
data = ISNULL(@data, data)
WHERE id_komentarza = @id_komentarza
END
GO

CREATE PROC spAktualizujFrekwencje
@id_lekcji numeric(8,0), @id_ucznia numeric(8,0), @frekwencja numeric(1,0) = null
AS
BEGIN
UPDATE Plan_lekcji
SET frekwencja = ISNULL(@frekwencja, frekwencja)
WHERE id_lekcji = @id_lekcji AND id_ucznia = @id_ucznia
END
GO

--sp_delete
CREATE PROC spUsunAdres
@adres_zamieszkania numeric(8,0)
AS
BEGIN
DELETE FROM adres_zamieszkania
WHERE adres_zamieszkania = @adres_zamieszkania
END
GO

CREATE PROC spUsunKlase
@id_klasy numeric(8,0)
AS
BEGIN
DELETE FROM Klasa
WHERE id_klasy = @id_klasy
END
GO

CREATE PROC spUsunLekcje
@id_lekcji numeric(8,0)
AS
BEGIN
DELETE FROM Lekcja
WHERE id_lekcji = @id_lekcji
END
GO

CREATE PROC spUsunNauczyciela
@id_nauczyciela numeric(8,0)
AS
BEGIN
DELETE FROM Nauczyciel
WHERE id_nauczyciela = @id_nauczyciela
END
GO

CREATE PROC spUsunOcene
@id_oceny numeric(8,0)
AS
BEGIN
DELETE FROM Ocena
WHERE id_oceny = @id_oceny
END
GO

CREATE PROC spUsunOpiekuna
@id_opiekuna numeric(8,0)
AS
BEGIN
DELETE FROM Opiekun
WHERE id_opiekuna = @id_opiekuna
END
GO

CREATE PROC spUsunUcznia
@id_ucznia numeric(8,0)
AS
BEGIN
DELETE FROM Uczen
WHERE id_ucznia = @id_ucznia
END
GO

CREATE PROC spUsunRelacjeUczen_Opiekun
@id_ucznia numeric(8,0)
AS
BEGIN
DELETE FROM uczen_opiekun
WHERE id_ucznia = @id_ucznia
END
GO

CREATE PROC spUsunKomentarz
@id_komentarza numeric(8,0)
AS
BEGIN
DELETE FROM Komentarz
WHERE id_komentarza = @id_komentarza
END
GO

CREATE PROC spUsunFrekwencje
@id_ucznia numeric(8,0)
AS
BEGIN
DELETE FROM Plan_lekcji
WHERE id_ucznia = @id_ucznia
END
GO

-- triggery

CREATE TRIGGER tr_Ocena_ForInsert
ON Ocena
FOR INSERT
AS
BEGIN
	DECLARE @ocena numeric(1,0), @id_ucz numeric(8,0), @id_naucz numeric(8,0)
	SELECT @ocena = ocena, @id_ucz = id_ucznia, @id_naucz = id_nauczyciela
	FROM inserted

	IF @ocena = 1
	BEGIN
		EXEC spDodajKomentarz 'Ostrzeżenie', 'Uczeń/Uczennica dostał/a ocenę niedsotateczną!', @id_ucz, @id_naucz
	END
	ELSE IF @ocena = 5
	BEGIN
		EXEC spDodajKomentarz 'Pochwała', 'Uczeń/Uczennica dostał/a bardzo dobrą ocenę', @id_ucz, @id_naucz
	END
END
GO

-- proc tworzenia i nadawania uprawnien uzytkownikom

CREATE PROC spStworzUzytkownika_Administrator  
@login varchar(30), @haslo varchar(16)  
AS  
BEGIN  
  
declare @s_login varchar(60)  
declare @s_haslo varchar(32)  
set @s_login = replace(@login,'''', '''''')  
set @s_haslo = replace(@haslo,'''', '''''')  
  
declare @sql nvarchar(max)  
SET @sql = 'CREATE LOGIN ' + @s_login + ' WITH PASSWORD = ''' + @s_haslo + '''; ' +   
'CREATE USER ' + @s_login + ' FOR LOGIN ' + @s_login + ';' 
EXEC (@sql)  
exec sp_addrolemember @rolename = 'db_owner', @membername = @s_login  
END
GO

-- hasło i login dla testowego administratora to admin, admin

CREATE PROC spStworzUzytkownika_Nauczyciel  
@login varchar(30), @haslo varchar(16)  
AS  
BEGIN  
  
declare @s_login varchar(60)  
declare @s_haslo varchar(32)  
set @s_login = replace(@login,'''', '''''')  
set @s_haslo = replace(@haslo,'''', '''''')  
  
declare @sql nvarchar(max)  
SET @sql = 'CREATE LOGIN ' + @s_login + ' WITH PASSWORD = ''' + @s_haslo + '''; ' +   
'CREATE USER ' + @s_login + ' FOR LOGIN ' + @s_login + ';' +  
'GRANT SELECT, INSERT, UPDATE, DELETE ON Ocena TO ' + @s_login + '; ' +   
'GRANT SELECT, INSERT, UPDATE, DELETE ON Komentarz TO ' + @s_login + '; ' +   
'GRANT SELECT ON Plan_lekcji TO ' + @s_login + '; ' +   
'GRANT SELECT ON Lekcja TO ' + @s_login + '; ' +   
'GRANT SELECT ON Klasa TO ' + @s_login + '; ' +   
'GRANT SELECT ON adres_zamieszkania TO ' + @s_login + '; ' +   
'GRANT SELECT ON Uczen TO ' + @s_login + '; ' +   
'GRANT SELECT ON uczen_opiekun TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spDodajOcene TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spUsunOcene TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spAktualizujOcene TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spDodajKomentarz TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spUsunKomentarz TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spAktualizujKomentarz TO ' + @s_login + '; ' +
'GRANT EXECUTE ON spWyswietlKlase TO ' + @s_login + '; ' +
'GRANT EXECUTE ON spWyswietlOcenyUcznia TO ' + @s_login + '; '
EXEC (@sql)  
END
GO

-- hasło i login dla testowego nauczyciela to Nauczyciel, 1234

CREATE PROC spStworzUzytkownika_Opiekun  
@login varchar(30), @haslo varchar(16)  
AS  
BEGIN  
  
declare @s_login varchar(60)  
declare @s_haslo varchar(32)  
set @s_login = replace(@login,'''', '''''')  
set @s_haslo = replace(@haslo,'''', '''''')  
  
declare @sql nvarchar(max)  
SET @sql = 'CREATE LOGIN ' + @s_login + ' WITH PASSWORD = ''' + @s_haslo + '''; ' +   
'CREATE USER ' + @s_login + ' FOR LOGIN ' + @s_login + ';' +  
'GRANT SELECT ON Plan_lekcji TO ' + @s_login + '; ' +   
'GRANT SELECT ON Ocena TO ' + @s_login + '; ' +   
'GRANT SELECT ON adres_zamieszkania TO ' + @s_login + '; ' +   
'GRANT SELECT ON Uczen TO ' + @s_login + '; ' +   
'GRANT SELECT ON Komentarz TO ' + @s_login + '; '  +
'GRANT EXECUTE ON spWyswietlOcenyUcznia TO ' + @s_login + '; '
EXEC (@sql)  
END
GO

-- hasło i login dla testowego opiekuna to Opiekun, 1234

CREATE PROC spStworzUzytkownika_Uczen
@login varchar(30), @haslo varchar(16)
AS
BEGIN

declare @s_login varchar(60)
declare @s_haslo varchar(32)
set @s_login = replace(@login,'''', '''''')
set @s_haslo = replace(@haslo,'''', '''''')

declare @sql nvarchar(max)
SET @sql = 'CREATE LOGIN ' + @s_login + ' WITH PASSWORD = ''' + @s_haslo + '''; ' + 
'CREATE USER ' + @s_login + ' FOR LOGIN ' + @s_login + ';' +
'GRANT SELECT ON Plan_lekcji TO ' + @s_login + '; ' + 
'GRANT SELECT ON Ocena TO ' + @s_login + '; ' +
'GRANT EXECUTE ON spWyswietlOcenyUcznia TO ' + @s_login + '; '
EXEC (@sql)
END
GO

-- hasło i login dla testowego ucznia to Uczen, 1234