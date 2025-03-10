create or replace PACKAGE manage_produkt IS
    PROCEDURE dodaj_produkt (
        p_nazwa IN PRODUKT.nazwa%TYPE,
        p_opis IN PRODUKT.opis%TYPE,
        p_cena IN PRODUKT.cena%TYPE,
        p_kategoria_nazwa IN PRODUKT.kategoria_nazwa%TYPE
    );

    PROCEDURE usun_produkt (
        p_nazwa IN PRODUKT.nazwa%TYPE
    );

    PROCEDURE zmien_dane_produktu (
        p_nazwa IN PRODUKT.nazwa%TYPE,
        p_opis IN PRODUKT.opis%TYPE,
        p_cena IN PRODUKT.cena%TYPE,
        p_kategoria_nazwa IN PRODUKT.kategoria_nazwa%TYPE
    );

    PROCEDURE dodaj_tag_do_produktu (
        p_nazwa IN HERB_RODZAJ.nazwa_produktu%TYPE,
        p_tag IN TAG.nazwa_tagu%TYPE
    );

    PROCEDURE dodaj_promocje_do_produktu (
        p_nazwa IN PRODUKT.nazwa%TYPE,
        p_nazwa_promocji IN tag_list
    );

    PROCEDURE dodaj_promocje (
        p_nazwa_promocji IN PROMOCJA.nazwa_promocji%TYPE,
        p_znizka IN PROMOCJA.znizka%TYPE,
        p_data_od IN PROMOCJA.data_od%TYPE,
        p_data_do IN PROMOCJA.data_do%TYPE
    );

    PROCEDURE usun_promocje (
        p_nazwa_promocji IN PROMOCJA.nazwa_promocji%TYPE
    );

    PROCEDURE dodaj_tag (
        p_nazwa_tagu IN TAG.nazwa_tagu%TYPE
    );
    PROCEDURE usun_tag (
        p_nazwa_tagu IN TAG.nazwa_tagu%TYPE
    );

    PROCEDURE dodaj_kategorie (
        p_nazwa IN KATEGORIA.nazwa%TYPE
    );
    PROCEDURE usun_kategorie (
        p_nazwa IN KATEGORIA.nazwa%TYPE
    );

    PROCEDURE dodaj_herb_rodzaj (
        p_temp_parz IN HERB_RODZAJ.temp_parz%TYPE,
        p_czas_parz IN HERB_RODZAJ.czas_parz%TYPE,
        p_kraj_poch IN HERB_RODZAJ.kraj_poch%TYPE,
        p_ile_parzen IN HERB_RODZAJ.ile_parzen%TYPE,
        p_moc IN HERB_RODZAJ.moc%TYPE,
        p_gatunek IN HERB_RODZAJ.gatunek%TYPE,
        p_aromatycznosc IN HERB_RODZAJ.aromatycznosc%TYPE,
        p_nazwa_produktu IN HERB_RODZAJ.nazwa_produktu%TYPE,
        p_tag_list IN tag_list
    );
    PROCEDURE zmien_herb_rodzaj (
        p_temp_parz IN HERB_RODZAJ.temp_parz%TYPE,
        p_czas_parz IN HERB_RODZAJ.czas_parz%TYPE,
        p_kraj_poch IN HERB_RODZAJ.kraj_poch%TYPE,
        p_ile_parzen IN HERB_RODZAJ.ile_parzen%TYPE,
        p_moc IN HERB_RODZAJ.moc%TYPE,
        p_gatunek IN HERB_RODZAJ.gatunek%TYPE,
        p_aromatycznosc IN HERB_RODZAJ.aromatycznosc%TYPE,
        p_nazwa_produktu IN HERB_RODZAJ.nazwa_produktu%TYPE,
        p_tag_list IN tag_list
    );
    PROCEDURE transkacja_produktu (
        p_nazwa_produktu IN ILOSC_PRODUKTU.nazwa_produktu%TYPE,
        p_ile IN ILOSC_PRODUKTU.ilosc%TYPE,
        p_kupno_sprzedaz IN ZAMOWIENIE.kupno_sprzedaz%TYPE,
        p_data_zamowienia IN ZAMOWIENIE.data_zamowienia%TYPE,
        p_nazwa_sprzedawcy IN ZAMOWIENIE.nazwa_sprzedawcy%TYPE,
        p_id_sklepu IN ZAMOWIENIE.id_sklepu%TYPE,
        p_po_ile IN ILOSC_PRODUKTU.po_ile%TYPE
    );

    PROCEDURE dodaj_zamowienie (
        p_data_zamowienia IN ZAMOWIENIE.data_zamowienia%TYPE,
        p_kupno_sprzedaz IN ZAMOWIENIE.kupno_sprzedaz%TYPE,
        p_nazwa_sprzedawcy IN ZAMOWIENIE.nazwa_sprzedawcy%TYPE,
        p_id_sklepu IN ZAMOWIENIE.id_sklepu%TYPE,
        p_id_zam OUT ZAMOWIENIE.id_zam%TYPE
    );

    PROCEDURE dodaj_produkt_do_zamowienia (
        p_nazwa_produktu IN ILOSC_PRODUKTU.nazwa_produktu%TYPE,
        p_id_zam IN ILOSC_PRODUKTU.id_zam%TYPE,
        p_ile IN ILOSC_PRODUKTU.ilosc%TYPE,
        p_po_ile IN ILOSC_PRODUKTU.po_ile%TYPE,
        p_kupno_sprzedaz IN ZAMOWIENIE.kupno_sprzedaz%TYPE,
        p_id_sklepu IN ZAMOWIENIE.id_sklepu%TYPE
    );
END manage_produkt;



create or replace PACKAGE BODY manage_produkt IS
    PROCEDURE dodaj_produkt (
        p_nazwa IN PRODUKT.nazwa%TYPE,
        p_opis IN PRODUKT.opis%TYPE,
        p_cena IN PRODUKT.cena%TYPE,
        p_kategoria_nazwa IN PRODUKT.kategoria_nazwa%TYPE
    ) AS
        v_check_kat NUMBER;
    BEGIN

        IF p_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Nazwa produktu nie może być pusta!');
        END IF;
        IF p_opis IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Opis nie może być pusty!');
        END IF;
        IF p_cena IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Cena nie może być pusta!');
        END IF;
        IF p_kategoria_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Kategoria nie może być pusta!');
        END IF;


        IF p_cena <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Podano niedodatnią cenę!');
        END IF;

        SELECT COUNT(*)
        INTO v_check_kat
        FROM KATEGORIA
        WHERE nazwa = p_kategoria_nazwa;

        IF v_check_kat = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'Prodana nazwa kategorii nie istnieje!');
        END IF;

        INSERT INTO PRODUKT(nazwa, opis, cena, kategoria_nazwa)
        VALUES (p_nazwa, p_opis, p_cena, p_kategoria_nazwa);
    END dodaj_produkt;

    PROCEDURE usun_produkt (
        p_nazwa IN PRODUKT.nazwa%TYPE
    ) AS
    BEGIN
        DELETE FROM PRODUKT WHERE nazwa = p_nazwa;
    END usun_produkt;

    PROCEDURE zmien_dane_produktu (
        p_nazwa IN PRODUKT.nazwa%TYPE,
        p_opis IN PRODUKT.opis%TYPE,
        p_cena IN PRODUKT.cena%TYPE,
        p_kategoria_nazwa IN PRODUKT.kategoria_nazwa%TYPE
    ) AS
        v_check_kat NUMBER;
    BEGIN

        IF p_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Nazwa produktu nie może być pusta!');
        END IF;
        IF p_opis IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Opis nie może być pusty!');
        END IF;
        IF p_cena IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Cena nie może być pusta!');
        END IF;
        IF p_kategoria_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Kategoria nie może być pusta!');
        END IF;
        
        IF p_cena <= 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Podano niedodatnią cenę!');
        END IF;

        SELECT COUNT(*)
        INTO v_check_kat
        FROM KATEGORIA
        WHERE nazwa = p_kategoria_nazwa;

        IF v_check_kat = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'Prodana nazwa kategorii nie istnieje!');
        END IF;

        UPDATE PRODUKT SET
            nazwa = p_nazwa,
            opis = p_opis,
            cena = p_cena,
            kategoria_nazwa = p_kategoria_nazwa
        WHERE nazwa = p_nazwa;
    END zmien_dane_produktu;

    PROCEDURE dodaj_tag_do_produktu (
        p_nazwa IN HERB_RODZAJ.nazwa_produktu%TYPE,
        p_tag IN TAG.nazwa_tagu%TYPE
    ) AS
        v_check_prod NUMBER;
        v_check_tag NUMBER;
    BEGIN
        IF p_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20035, 'Nazwa tagu nie może być pusta.');
        END IF;

        SELECT COUNT(*)
        INTO v_check_prod
        FROM HERB_RODZAJ
        WHERE nazwa_produktu = p_nazwa;

        IF v_check_prod = 0 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Prodana nazwa produktu nie istnieje!');
        END IF;

        SELECT COUNT(*)
        INTO v_check_tag
        FROM TAG
        WHERE nazwa_tagu = p_tag;

        IF v_check_tag = 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Prodana nazwa tagu nie istnieje!');
        END IF;

        INSERT INTO HERBATA_TAG(nazwa_produktu, tag_nazwa)
        VALUES (p_nazwa, p_tag);
    END dodaj_tag_do_produktu;

    PROCEDURE dodaj_promocje_do_produktu (
        p_nazwa IN PRODUKT.nazwa%TYPE,
        p_nazwa_promocji IN tag_list
    ) AS
    BEGIN

        DELETE FROM PRODUKT_NA_PROMOCJI
        WHERE nazwa_produktu = p_nazwa;

        IF p_nazwa_promocji IS NOT NULL THEN
            FOR i IN 1 .. p_nazwa_promocji.COUNT LOOP
                INSERT INTO PRODUKT_NA_PROMOCJI(nazwa_produktu, nazwa_promocji)
                VALUES (p_nazwa, p_nazwa_promocji(i));
            END LOOP;
        END IF;
    END dodaj_promocje_do_produktu;

    PROCEDURE dodaj_promocje (
        p_nazwa_promocji IN PROMOCJA.nazwa_promocji%TYPE,
        p_znizka IN PROMOCJA.znizka%TYPE,
        p_data_od IN PROMOCJA.data_od%TYPE,
        p_data_do IN PROMOCJA.data_do%TYPE
    ) AS
    BEGIN

        IF p_znizka <= 0 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Podano niedodatnią zniżkę!');
        END IF;

        IF p_nazwa_promocji IS NULL THEN
            RAISE_APPLICATION_ERROR(-20303, 'Nazwa promocji nie może być pusta.');
        END IF;

        IF p_znizka IS NULL THEN
            RAISE_APPLICATION_ERROR(-20304, 'Zniżka nie może być pusta.');
        END IF;

        IF p_data_od IS NULL THEN
            RAISE_APPLICATION_ERROR(-20305, 'Data nie może być pusta.');
        END IF;

        IF p_data_do IS NULL THEN
            RAISE_APPLICATION_ERROR(-20306, 'Data nie może być pusta.');
        END IF;
        
        INSERT INTO PROMOCJA(nazwa_promocji, znizka, data_od, data_do)
        VALUES (p_nazwa_promocji, p_znizka, p_data_od, p_data_do);
    END dodaj_promocje;

    PROCEDURE usun_promocje (
        p_nazwa_promocji IN PROMOCJA.nazwa_promocji%TYPE
    ) AS
    BEGIN
        DELETE FROM PROMOCJA WHERE nazwa_promocji = p_nazwa_promocji;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20051, 'Nie można usunąc promocji, na której są przedmioty.');
    END usun_promocje;

    PROCEDURE dodaj_tag (
        p_nazwa_tagu IN TAG.nazwa_tagu%TYPE
    ) AS v_check_tag NUMBER;
    BEGIN
        IF p_nazwa_tagu IS NULL THEN
            RAISE_APPLICATION_ERROR(-20103, 'Nazwa tagu nie może być pusta.');
        END IF;

        SELECT COUNT(*)
        INTO v_check_tag
        FROM TAG
        WHERE nazwa_tagu = p_nazwa_tagu;
        IF v_check_tag > 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'Podany tag już istnieje!');
        END IF;

        INSERT INTO TAG(nazwa_tagu)
        VALUES (p_nazwa_tagu);
    END dodaj_tag;

    PROCEDURE usun_tag (
        p_nazwa_tagu IN TAG.nazwa_tagu%TYPE
    ) AS
    BEGIN
        DELETE FROM TAG WHERE nazwa_tagu = p_nazwa_tagu;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20051, 'Nie można usunąc tagu, przedmiot ma przypisany ten tag.');
    END usun_tag;  


    PROCEDURE dodaj_kategorie (
        p_nazwa IN KATEGORIA.nazwa%TYPE
    ) AS v_check_kat NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_check_kat
        FROM KATEGORIA
        WHERE nazwa = p_nazwa;

        IF v_check_kat > 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'Prodana kategoria już istnieje!');
        END IF;

        IF p_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20403, 'Nazwa kategorii nie może być pusta.');
        END IF;

        INSERT INTO KATEGORIA(nazwa)
        VALUES (p_nazwa);
    END dodaj_kategorie;
    PROCEDURE usun_kategorie (
        p_nazwa IN KATEGORIA.nazwa%TYPE
    ) AS
    BEGIN
        DELETE FROM KATEGORIA WHERE nazwa = p_nazwa;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20051, 'Nie można usunąc kategorii, w której znajdują się przedmioty.');
    END usun_kategorie;  

    PROCEDURE dodaj_herb_rodzaj (
        p_temp_parz IN HERB_RODZAJ.temp_parz%TYPE,
        p_czas_parz IN HERB_RODZAJ.czas_parz%TYPE,
        p_kraj_poch IN HERB_RODZAJ.kraj_poch%TYPE,
        p_ile_parzen IN HERB_RODZAJ.ile_parzen%TYPE,
        p_moc IN HERB_RODZAJ.moc%TYPE,
        p_gatunek IN HERB_RODZAJ.gatunek%TYPE,
        p_aromatycznosc IN HERB_RODZAJ.aromatycznosc%TYPE,
        p_nazwa_produktu IN HERB_RODZAJ.nazwa_produktu%TYPE,
        p_tag_list IN tag_list
    ) AS
        v_check_prod NUMBER;
    BEGIN



        IF p_temp_parz IS NULL THEN
            RAISE_APPLICATION_ERROR(-20020, 'Temperatura parzenia nie może być pusta!');
        END IF;

        IF p_czas_parz IS NULL THEN
            RAISE_APPLICATION_ERROR(-20021, 'Czas parzenia nie może być pusta!');
        END IF;

        IF p_kraj_poch IS NULL THEN
            RAISE_APPLICATION_ERROR(-20022, 'Kraj pochodzenia nie może być pusta!');
        END IF;

        IF p_ile_parzen IS NULL THEN
            RAISE_APPLICATION_ERROR(-20023, 'Ilość parzeń nie może być pusta!');
        END IF;

        IF p_moc IS NULL THEN
            RAISE_APPLICATION_ERROR(-20024, 'Moc herbaty nie może być pusta!');
        END IF;

        IF p_gatunek IS NULL THEN
            RAISE_APPLICATION_ERROR(-20025, 'Gatunek herbaty nie może być pusta!');
        END IF;

        IF p_aromatycznosc IS NULL THEN
            RAISE_APPLICATION_ERROR(-20026, 'Aromatyczność herbaty nie może być pusta!');
        END IF;

        IF p_nazwa_produktu IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Nazwa produktu nie może być pusta!');
        END IF;

        SELECT COUNT(*)
        INTO v_check_prod
        FROM PRODUKT
        WHERE nazwa = p_nazwa_produktu;

        IF v_check_prod = 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Podana nazwa produktu nie istnieje!');
        END IF;

        IF p_temp_parz <= 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Podano niedodatnią temperaturę!');
        END IF;

        IF p_czas_parz <= 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Podano niedodatni czas parzenia!');
        END IF;

        INSERT INTO HERB_RODZAJ(temp_parz, czas_parz, kraj_poch, ile_parzen, moc, gatunek, aromatycznosc, nazwa_produktu)
        VALUES (p_temp_parz, p_czas_parz, p_kraj_poch, p_ile_parzen, p_moc, p_gatunek, p_aromatycznosc, p_nazwa_produktu);

        IF p_tag_list IS NOT NULL THEN
            FOR i IN 1 .. p_tag_list.COUNT LOOP
                INSERT INTO HERBATA_TAG(nazwa_produktu, tag_nazwa)
                VALUES (p_nazwa_produktu, p_tag_list(i));
            END LOOP;
        END IF;

    END dodaj_herb_rodzaj;

    PROCEDURE zmien_herb_rodzaj (
        p_temp_parz IN HERB_RODZAJ.temp_parz%TYPE,
        p_czas_parz IN HERB_RODZAJ.czas_parz%TYPE,
        p_kraj_poch IN HERB_RODZAJ.kraj_poch%TYPE,
        p_ile_parzen IN HERB_RODZAJ.ile_parzen%TYPE,
        p_moc IN HERB_RODZAJ.moc%TYPE,
        p_gatunek IN HERB_RODZAJ.gatunek%TYPE,
        p_aromatycznosc IN HERB_RODZAJ.aromatycznosc%TYPE,
        p_nazwa_produktu IN HERB_RODZAJ.nazwa_produktu%TYPE,
        p_tag_list IN tag_list
    ) AS
        v_check_prod NUMBER;
    BEGIN
        IF p_temp_parz IS NULL THEN
            RAISE_APPLICATION_ERROR(-20020, 'Temperatura parzenia nie może być pusta!');
        END IF;

        IF p_czas_parz IS NULL THEN
            RAISE_APPLICATION_ERROR(-20021, 'Czas parzenia nie może być pusta!');
        END IF;

        IF p_kraj_poch IS NULL THEN
            RAISE_APPLICATION_ERROR(-20022, 'Kraj pochodzenia nie może być pusta!');
        END IF;

        IF p_ile_parzen IS NULL THEN
            RAISE_APPLICATION_ERROR(-20023, 'Ilość parzeń nie może być pusta!');
        END IF;

        IF p_moc IS NULL THEN
            RAISE_APPLICATION_ERROR(-20024, 'Moc herbaty nie może być pusta!');
        END IF;

        IF p_gatunek IS NULL THEN
            RAISE_APPLICATION_ERROR(-20025, 'Gatunek herbaty nie może być pusta!');
        END IF;

        IF p_aromatycznosc IS NULL THEN
            RAISE_APPLICATION_ERROR(-20026, 'Aromatyczność herbaty nie może być pusta!');
        END IF;

        IF p_nazwa_produktu IS NULL THEN
            RAISE_APPLICATION_ERROR(-20027, 'Nazwa produktu nie może być pusta!');
        END IF;


        SELECT COUNT(*)
        INTO v_check_prod
        FROM PRODUKT
        WHERE nazwa = p_nazwa_produktu;

        IF v_check_prod = 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Podana nazwa produktu nie istnieje!');
        END IF;

        IF p_temp_parz <= 0 THEN
            RAISE_APPLICATION_ERROR(-20011, 'Podano niedodatnią temperaturę!');
        END IF;

        IF p_czas_parz <= 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Podano niedodatni czas parzenia!');
        END IF;

        UPDATE HERB_RODZAJ SET
            temp_parz = p_temp_parz, 
            czas_parz = p_czas_parz, 
            kraj_poch = p_kraj_poch, 
            ile_parzen = p_ile_parzen, 
            moc = p_moc, 
            gatunek = p_gatunek, 
            aromatycznosc = p_aromatycznosc
        WHERE nazwa_produktu = p_nazwa_produktu;

        DELETE FROM HERBATA_TAG
        WHERE nazwa_produktu = p_nazwa_produktu;

        IF p_tag_list IS NOT NULL THEN
            FOR i IN 1 .. p_tag_list.COUNT LOOP
                INSERT INTO HERBATA_TAG(nazwa_produktu, tag_nazwa)
                VALUES (p_nazwa_produktu, p_tag_list(i));
            END LOOP;
        END IF;

    END zmien_herb_rodzaj;


    PROCEDURE transkacja_produktu (
        p_nazwa_produktu IN ILOSC_PRODUKTU.nazwa_produktu%TYPE,
        p_ile IN ILOSC_PRODUKTU.ilosc%TYPE,
        p_kupno_sprzedaz IN ZAMOWIENIE.kupno_sprzedaz%TYPE,
        p_data_zamowienia IN ZAMOWIENIE.data_zamowienia%TYPE,
        p_nazwa_sprzedawcy IN ZAMOWIENIE.nazwa_sprzedawcy%TYPE,
        p_id_sklepu IN ZAMOWIENIE.id_sklepu%TYPE,
        p_po_ile IN ILOSC_PRODUKTU.po_ile%TYPE
    ) AS 
        v_id_zam ILOSC_PRODUKTU.id_zam%TYPE;
        v_dostepnosc STAN_SKLEPU.dostepnosc%TYPE;
    BEGIN

        IF p_kupno_sprzedaz = 'S' THEN
            SELECT dostepnosc
            INTO v_dostepnosc
            FROM STAN_SKLEPU
            WHERE nazwa_produktu = p_nazwa_produktu AND id_sklep = p_id_sklepu;

            IF v_dostepnosc < p_ile THEN
                RAISE_APPLICATION_ERROR(-20030, 'Nie można sprzedac więcej niż było w magazynie!');
            END IF;
        END IF;

        INSERT INTO ZAMOWIENIE (data_zamowienia, kupno_sprzedaz, nazwa_sprzedawcy, id_sklepu)
        VALUES (p_data_zamowienia, p_kupno_sprzedaz, p_nazwa_sprzedawcy, p_id_sklepu)
        RETURNING id_zam INTO v_id_zam;

        INSERT INTO ILOSC_PRODUKTU (nazwa_produktu, id_zam, ilosc, po_ile)
        VALUES (p_nazwa_produktu, v_id_zam, p_ile, p_po_ile);

        IF p_kupno_sprzedaz = 'K' THEN
            UPDATE STAN_SKLEPU SET
                dostepnosc = dostepnosc + p_ile
            WHERE nazwa_produktu = p_nazwa_produktu;
        END IF;
        IF p_kupno_sprzedaz = 'S' THEN
            UPDATE STAN_SKLEPU SET
                dostepnosc = dostepnosc - p_ile
            WHERE nazwa_produktu = p_nazwa_produktu;
        END IF;

    END transkacja_produktu;  

    PROCEDURE dodaj_zamowienie (
        p_data_zamowienia IN ZAMOWIENIE.data_zamowienia%TYPE,
        p_kupno_sprzedaz IN ZAMOWIENIE.kupno_sprzedaz%TYPE,
        p_nazwa_sprzedawcy IN ZAMOWIENIE.nazwa_sprzedawcy%TYPE,
        p_id_sklepu IN ZAMOWIENIE.id_sklepu%TYPE,
        p_id_zam OUT ZAMOWIENIE.id_zam%TYPE
    ) AS
    BEGIN
        INSERT INTO ZAMOWIENIE (data_zamowienia, kupno_sprzedaz, nazwa_sprzedawcy, id_sklepu)
        VALUES (p_data_zamowienia, p_kupno_sprzedaz, p_nazwa_sprzedawcy, p_id_sklepu)
        RETURNING id_zam INTO p_id_zam;
    END dodaj_zamowienie;


    PROCEDURE dodaj_produkt_do_zamowienia (
        p_nazwa_produktu IN ILOSC_PRODUKTU.nazwa_produktu%TYPE,
        p_id_zam IN ILOSC_PRODUKTU.id_zam%TYPE,
        p_ile IN ILOSC_PRODUKTU.ilosc%TYPE,
        p_po_ile IN ILOSC_PRODUKTU.po_ile%TYPE,
        p_kupno_sprzedaz IN ZAMOWIENIE.kupno_sprzedaz%TYPE,
        p_id_sklepu IN ZAMOWIENIE.id_sklepu%TYPE
    ) AS
        v_dostepnosc STAN_SKLEPU.dostepnosc%TYPE;
    BEGIN
        IF p_kupno_sprzedaz = 'S' THEN
            SELECT dostepnosc
            INTO v_dostepnosc
            FROM STAN_SKLEPU
            WHERE nazwa_produktu = p_nazwa_produktu AND id_sklep = p_id_sklepu;

            IF v_dostepnosc < p_ile THEN
                RAISE_APPLICATION_ERROR(-20030, 'Nie można sprzedać więcej niż dostępne w magazynie!');
            END IF;
        END IF;

        INSERT INTO ILOSC_PRODUKTU (nazwa_produktu, id_zam, ilosc, po_ile)
        VALUES (p_nazwa_produktu, p_id_zam, p_ile, p_po_ile);

        IF p_kupno_sprzedaz = 'K' THEN
            UPDATE STAN_SKLEPU SET
                dostepnosc = dostepnosc + p_ile
            WHERE nazwa_produktu = p_nazwa_produktu AND id_sklep = p_id_sklepu;
        ELSIF p_kupno_sprzedaz = 'S' THEN
            UPDATE STAN_SKLEPU SET
                dostepnosc = dostepnosc - p_ile
            WHERE nazwa_produktu = p_nazwa_produktu AND id_sklep = p_id_sklepu;
        END IF;
    END dodaj_produkt_do_zamowienia;


END;




create or replace PACKAGE manage_pracownik IS
    PROCEDURE dodaj_pracownika (
        p_imie IN PRACOWNIK.imie%TYPE,
        p_nazwisko IN PRACOWNIK.nazwisko%TYPE,
        p_pensja_brutto IN PRACOWNIK.pensja_brutto%TYPE,
        p_data IN PRACOWNIK.data_zatrudnienia%TYPE,
        p_data_zw IN PRACOWNIK.data_zwolnienia%TYPE,
        p_sklep_id IN PRACOWNIK.sklep_id%TYPE,
        p_stanowisko_nazwa IN PRACOWNIK.stanowisko_nazwa%TYPE
    );

    PROCEDURE usun_pracownika (
        p_id_prac IN PRACOWNIK.id_prac%TYPE
    );

    PROCEDURE zmien_dane (
        p_id_prac IN PRACOWNIK.id_prac%TYPE,
        p_imie IN PRACOWNIK.imie%TYPE,
        p_nazwisko IN PRACOWNIK.nazwisko%TYPE,
        p_pensja_brutto IN PRACOWNIK.pensja_brutto%TYPE,
        p_data IN PRACOWNIK.data_zatrudnienia%TYPE,
        p_data_zw IN PRACOWNIK.data_zwolnienia%TYPE,
        p_sklep_id IN PRACOWNIK.sklep_id%TYPE,
        p_stanowisko_nazwa IN PRACOWNIK.stanowisko_nazwa%TYPE
    );

    PROCEDURE dodaj_stanowisko (
        p_nazwa IN STANOWISKO.nazwa%TYPE
    );

    PROCEDURE usun_stanowisko (
        p_nazwa IN STANOWISKO.nazwa%TYPE
    );

END manage_pracownik;


create or replace PACKAGE BODY manage_pracownik IS
    PROCEDURE dodaj_pracownika (
        p_imie IN PRACOWNIK.imie%TYPE,
        p_nazwisko IN PRACOWNIK.nazwisko%TYPE,
        p_pensja_brutto IN PRACOWNIK.pensja_brutto%TYPE,
        p_data IN PRACOWNIK.data_zatrudnienia%TYPE,
        p_data_zw IN PRACOWNIK.data_zwolnienia%TYPE,
        p_sklep_id IN PRACOWNIK.sklep_id%TYPE,
        p_stanowisko_nazwa IN PRACOWNIK.stanowisko_nazwa%TYPE
    ) AS
    BEGIN
    

        IF p_imie IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Imię pracownika nie może być puste!');
        END IF;

        IF p_nazwisko IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nazwisko pracownika nie może być puste!');
        END IF;

        IF p_pensja_brutto IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Pensja brutto pracownika nie może być pusta!');
        END IF;

        IF p_data IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'Data zatrudnienia pracownika nie może być pusta!');
        END IF;

        IF p_sklep_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'ID sklepu nie może być puste!');
        END IF;

        IF p_stanowisko_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20006, 'Nazwa stanowiska nie może być pusta!');
        END IF;

        IF p_pensja_brutto <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Podano niedodatnią pensję!');
        END IF;

        INSERT INTO PRACOWNIK(imie, nazwisko, pensja_brutto, data_zatrudnienia, sklep_id, stanowisko_nazwa, data_zwolnienia)
        VALUES (p_imie, p_nazwisko, p_pensja_brutto, p_data, p_sklep_id, p_stanowisko_nazwa, p_data_zw);
    END dodaj_pracownika;

    PROCEDURE usun_pracownika (
        p_id_prac IN PRACOWNIK.id_prac%TYPE
    ) AS
    BEGIN
        DELETE FROM PRACOWNIK WHERE id_prac = p_id_prac;
    END usun_pracownika;

    PROCEDURE zmien_dane (
        p_id_prac IN PRACOWNIK.id_prac%TYPE,
        p_imie IN PRACOWNIK.imie%TYPE,
        p_nazwisko IN PRACOWNIK.nazwisko%TYPE,
        p_pensja_brutto IN PRACOWNIK.pensja_brutto%TYPE,
        p_data IN PRACOWNIK.data_zatrudnienia%TYPE,
        p_data_zw IN PRACOWNIK.data_zwolnienia%TYPE,
        p_sklep_id IN PRACOWNIK.sklep_id%TYPE,
        p_stanowisko_nazwa IN PRACOWNIK.stanowisko_nazwa%TYPE
    ) AS
    BEGIN


        IF p_imie IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Imię pracownika nie może być puste!');
        END IF;

        IF p_nazwisko IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nazwisko pracownika nie może być puste!');
        END IF;

        IF p_pensja_brutto IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Pensja brutto pracownika nie może być pusta!');
        END IF;

        IF p_data IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'Data zatrudnienia pracownika nie może być pusta!');
        END IF;

        IF p_sklep_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'ID sklepu nie może być puste!');
        END IF;

        IF p_stanowisko_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20005, 'Nazwa stanowiska nie może być pusta!');
        END IF;

        IF p_pensja_brutto <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Podano niedodatnią pensję!');
        END IF;

        UPDATE PRACOWNIK SET
            imie = p_imie,
            nazwisko = p_nazwisko,
            pensja_brutto = p_pensja_brutto,
            data_zatrudnienia = p_data,
            data_zwolnienia = p_data_zw,
            sklep_id = p_sklep_id,
            stanowisko_nazwa = p_stanowisko_nazwa
        WHERE id_prac = p_id_prac;
    END zmien_dane;

    PROCEDURE dodaj_stanowisko
    (
        p_nazwa IN STANOWISKO.nazwa%TYPE
    ) AS
        v_count INTEGER;
    BEGIN
        IF p_nazwa IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Nazwa stanowiska nie może być pusta.');
        END IF;

        SELECT COUNT(*)
        INTO v_count
        FROM stanowisko
        WHERE nazwa = p_nazwa;
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Dane stanowisko już istnieje.');
        ELSE
            INSERT INTO STANOWISKO VALUES(p_nazwa);
        END IF;

    END dodaj_stanowisko;

    PROCEDURE usun_stanowisko
    (
        p_nazwa IN STANOWISKO.nazwa%TYPE
    ) AS
    BEGIN
        DELETE FROM STANOWISKO WHERE nazwa = p_nazwa;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20051, 'Nie można usunąc stanowiska, istenije pracownik na takim stanowisku.');
    END usun_stanowisko;
END;



CREATE OR REPLACE FUNCTION ostatni_id_zam
RETURN ZAMOWIENIE.id_zam%TYPE
AS
    v_ostatni_id ZAMOWIENIE.id_zam%TYPE;
BEGIN
    SELECT MAX(id_zam)
    INTO v_ostatni_id
    FROM ZAMOWIENIE;

    RETURN v_ostatni_id;
END ostatni_id_zam;