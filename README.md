# Zadanie testowe
Sierpień 2021


## Opis zadania:
* Głównym celem jest pobranie z serwisu GitHub listy repozytoriów, których nazwa lub opis (name, description) zawiera słowa wpisane w polu tekstowym i wyświetlenie ich w formie listy.
* Wybranie elementu z listy powoduje pokazanie ekranu, na którym wyświetlona zostanie strona z wskazanym repozytorium.
* Zastosowano architekturę MVVM rozszerzoną o koordynator i dependency injection.


## Realizacja zadania:
Projekt składa się z dwóch view kontrolerów, które obsługiwane są przez koordynator.

### 1. Ekran listy (*ListViewController*)
* *view* modułu składa się z czterech komponentów: pola tekstowego, przycisku wyszukującego repozytoria, listy wyników oraz wskaźnika pobierania
* po wpisaniu szukanej frazy i wciśnięciu przycisku z lupką lub wybraniu przycisku *szukaj* na klawiaturze, następuje wywołanie z *viewModelu* metody pobierającej dane z *DataService*
* na czas pobierania danych tabela jest ukrywana i pokazywany jest wskaźnik pobierania
* jeśli proces pobierania danych zakończy się błędem, kontroler wysła informację do koordynatora, który wyświetla stosowny komunikat
* wskazanie elementu listy powoduje powiadomienie koordynatora o zdarzeniu, jednocześnie przekazywane są dane związane z wskazanym elementem tabeli
* jesli pole tekstowe jest puste, to przycisk wyszukiwania jest nieaktywny
* liczba znalezionych wyników prezentowana jest w nagłówku ekranu

### 2. Ekran repozytorium (*RepoDetailsViewController*)
* jedynym zadaniem tego modułu jest prezentacja strony z repozytorium
* informacje o repozytorium, które ma zostać wyświetlone są przekazywane do *viewModelu* podczas jego inicjalizacji

## UI:
* wszystkiew elementy UI zostały utworzone w kodzie
* do ich poprawnego rozmieszczenia na ekranie zastosowano *AutoLayout* zrealizowany za pomocą biblioteki ***SnapKit***
* do nawigacji pomiędzy kontrolerami wykorzystano *UINavigationController*
* projekt wspiera **Dark Mode**, a kolory wykorzystywane w projekcie są definiowane w *ColorAssets.xcassets*, do których jest dostęp poprzez strukturę *AppColor*

## Networking:
Za warstwę networkingu odpowiada prosty serwis *DataService* oparty o **URLSession**.
W projekcie dane pobierane są tylko z jednego endpoint’u i jednego typu zapytania, nie było więc potrzeby tworzenia bardziej rozbudowanego rozwiązania.

W typowych aplikacjach mobilnych, gdzie wysyłanych jest wiele różnych requestów, zastosowałbym bardziej złożone rozwiązanie, przy czym wspólnym elementem serwisów byłoby odwoływanie się do niego poprzez protokół.

## Error handling:
Podczas pobierania danych z endpointu może wydarzyć się wiele nieprzewidzianych zdarzeń, kończących się niepowodzeniem. Z tego powodu dodano customową obsługę błędów. Celem było:

* informowanie użytkownika o każdym problemie
* umożliwienie użytkownikowi powtórzenia akcji - powtórne wysłanie requestu

## Dependencies:
W projekcie celowo zrezygnowałem z korzystania z *CocoaPods* - dodawanie zewnętrznych bibliotek zrealizowałem poprzez **SPM**.

W projekcie wykorzystana jest tylko jedna biblioteka: **SnapKit**, która wspomaga proces tworzenia widoków za pomocą kodu. Bez problemu mógłbym poradzić sobie bez niej - Apple oferuje kilka natywnych technik tworzenia autolayoutu, są one jednak trochę bardziej czasochłonne.
