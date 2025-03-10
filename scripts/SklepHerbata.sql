CREATE TABLE Produkt (
    nazwa VARCHAR2(50) NOT NULL PRIMARY KEY,
    opis VARCHAR2(4000) NOT NULL,
    cena NUMBER(8,2) NOT NULL,
    data_dod DATE DEFAULT SYSDATE NOT NULL,
    kategoria_nazwa VARCHAR2(50) NOT NULL REFERENCES Kategoria(nazwa),
);

CREATE TABLE Kategoria (
    nazwa VARCHAR2(50) PRIMARY KEY
);

CREATE TABLE Promocja (
    nazwa_promocji VARCHAR2(50) PRIMARY KEY,
    znizka NUMBER(3,2) NOT NULL,
    czy_aktywna NUMBER(1) NOT NULL,
    data_od DATE NOT NULL,
    data_do DATE NOT NULL,

    CONSTRAINT chk_value_range CHECK (znizka >= 0 AND znizka <= 1)
);

CREATE TABLE Produkt_na_promocji (
    nazwa_produktu NUMBER NOT NULL REFERENCES Produkt(nazwa),
    nazwa_promocji VARCHAR2(50) NOT NULL REFERENCES Promocja(nazwa_promocji),
    PRIMARY KEY (nazwa_produktu, nazwa_promocji)
);

CREATE TABLE Herb_rodzaj (
    temp_parz NUMBER(3) NOT NULL,
    czas_parz NUMBER(5) NOT NULL,
    kraj_poch VARCHAR2(30) NOT NULL,
    ile_parzen NUMBER(2) NOT NULL,
    moc NUMBER(1) NOT NULL,
    gatunek VARCHAR2(20) NOT NULL,
    aromatycznosc NUMBER(1) NOT NULL,
    nazwa_produktu NUMBER PRIMARY KEY REFERENCES Produkt(nazwa)
);


CREATE TABLE Tag (
    nazwa_tagu VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Herbata_Tag (
    nazwa_produktu NUMBER NOT NULL REFERENCES Herb_rodzaj(nazwa_produktu),
    tag_nazwa VARCHAR2 NOT NULL REFERENCES Tag(nazwa_tagu),
    PRIMARY KEY (nazwa_produktu, tag_nazwa)
);


CREATE TABLE Ilosc_produktu (
    nazwa_produktu NUMBER NOT NULL REFERENCES Produkt(nazwa),
    id_zam INTEGER NOT NULL REFERENCES Zamowienie(id_zam),
    ilosc INTEGER NOT NULL,
    po_ile NUMBER(8,2),
    PRIMARY KEY (nazwa_produktu, id_zam)
);

CREATE TABLE Zamowienie (
    id_zam INTEGER PRIMARY KEY,
    data_zamowienia DATE NOT NULL,
    kupno_sprzedaz CHAR(1) NOT NULL,
    nazwa_sprzedawcy VARCHAR,
    id_sklepu NUMBER NOT NULL REFERENCES Sklep(id_sklep)
);

CREATE TABLE Stan_sklepu (
    id_sklep INTEGER NOT NULL REFERENCES Sklep(id_sklep),
    nazwa_produktu NUMBER NOT NULL REFERENCES Produkt(nazwa),
    dostepnosc NUMBER(5) NOT NULL,
    PRIMARY KEY (id_sklep, nazwa_produktu)
);

CREATE TABLE Sklep (
    id_sklep INTEGER PRIMARY KEY,
    adres VARCHAR NOT NULL, 
    kod_pocz VARCHAR NOT NULL,
    miasto VARCHAR NOT NULL
);

CREATE TABLE Pracownik (
    id_prac INTEGER PRIMARY KEY,
    imie VARCHAR NOT NULL,
    nazwisko VARCHAR NOT NULL,
    pensja_brutto NUMERIC NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    sklep_id INTEGER REFERENCES Sklep(id_sklep) NOT NULL,
    stanowisko_nazwa VARCHAR REFERENCES Stanowisko(nazwa) NOT NULL
);

CREATE TABLE Stanowisko (
    nazwa VARCHAR PRIMARY KEY
);