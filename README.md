# Projekt bazy danych dostaw

Baza danych odnosić się będzie do sieci sklepów robotów domowych, magazynów z których dostarczane będą produkty, dostawców obsługujących dane dostawy, produktów, dostaw na poszczególnych trasach, miast i województw oraz najważniejszych zamówień łączących system dystrybucji. Służyć ma to lepszemu zorganizowaniu uzupełnień do sklepów z magazynów. Sklepy wystawiają zamówienie na dany produkt i jego ilość a dostawa robiona jest samoistnie wraz z wybraniem wolnego dostawcy. Po przesłaniu informacji do Magazynu i Dostawcy, zamówienie jest realizowane. W przypadku braku wolnego dostawcy zamówienie zostanie zrealizowane w późniejszym terminie.

Najważniejsze procedury uzupełniania wskazanego wiersza w tabeli:
- Aktualizacja statusu Dostawcy
Ma za zadanie pomóc w ustawianiu statusu zajętości dostawcy.
- Aktualizacja informacji o produkcie
Uaktualnia informacje takie jak cena produktu.
- Aktualizacja danych w zamówieniu
Służy edycji danych jak cel zamówienia i ilość produktów.
Ponadto do każdej tabeli istnieje procedura wstawiania danych.
Triggery Insert:
- Gdy dodamy nowe zamówienie automatycznie wpisujemy jego koszt na podstawie ilości zamówionego produktu.
- Gdy dodajemy sklep dodawane jest zamówienie na produkty by nowopowstały punkt sprzedaży nie był pusty.
Triggery Delete: • Gdy usuwamy Produkt, opróżniamy przypisane magazyny
- Gdy usuwamy zamówienie to usuwamy dostawę z magazynu i zwalniamy status dostawcy.
Triggery Update:
- Aktualizacja Produktu zmienia automatycznie informacje w jego zamówieniach, dotyczy to ceny produktu a więc sumarycznego kosztu zamówienia. • Aktualizacja Sklepu sprawdza czy wprowadzono poprawną ilość produktów w sklepie po zrealizowanych dostawach, jeśli ilości się zgadzają, zeruje zamówienie jako że produkty zostały dostarczone.
- Aktualizacja Dostawy sprawdza dostępność danego dostawcy do zrealizowania danej dostawy.
- Aktualizacja Zamówienia sprawdza czy zmieniono status realizacji na wykonano (BIT ustawiony na 1), jeśli tak, usuwa dostawę i zwalnia status dostawcy.
Procedury dodawania do wielu tabel:
- Dodawanie nowego Zamówienia wiąże się z dodaniem nowej Dostawy i przypisaniem wolnego dostawcy.
- Dodanie zupełnie nowego produktu wraz z dodaniem nowego magazynu do przechowywania.

## Schemat Bazy

<img src="https://github.com/wasikm04/Distribution_Database/blob/master/schemat.png" width="800"/>