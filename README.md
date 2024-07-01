<<<<<<< HEAD
# Projekt-ZMUM-WMUM
=======
# Wstęp

Repozytorium zawiera projekt końcowy z dwóch przedmiotów: Zaawanasowane metody uczenia maszynowego oraz Wdrażanie modeli uczenia maszynowego. 
Tematem projektu jest przewidywanie ceny złota na podstawie notowań od roku 1970 do 2020. Zbiór danych został zaczerpnięty ze strony 
https://www.kaggle.com/datasets/arashnic/learn-time-series-forecasting-from-gold-price .

Projekt składa się z dwóch głównych części:
1. Raport z budowy modeli przygotowany w Juputer Notebook (plik `projektzmum.ipynb`) - zawiera opis projektu, wstępną analizę i przetwarzanie danych oraz budowę  modeli do przewidywania ceny złota.
2. Aplikacja przygotowana za pomocą pakietu shiny (plik `app.R` w folderze `shiny-app`).

Pozostałe pliki:
- zbiór danych `gold_price_data.csv`,
- folder `models` zawierający zapisane po budowie modele.

# Budowa modeli
W pierwszej części projektu zbudowane zostały modele predykcyjne:
- model bazowy - opierający się na heurystyce, że cena za 30 dni będzie taka sama jak obecna cena,
- modele oparte na uczeniu maszynowym - drzewo i svm,
- modele oparte na głębokim uczeniu - różne rodzaje sieci neuronowych.

# Aplikacja shiny
## Uruchomienie
Po pobraniu zawartości tego repozytorium na swój komputer, należy uruchomić plik `app.R`.

## Opis aplikacji
Aplikacja składa się z trzech zakładek.

Pierwsza zakładka zawiera opis aplikacji oraz ustawienia interfejsu użytkownika.

![image](https://github.com/edyta01m/Projekt-ZMUM-WMUM/assets/115696466/9919934d-c397-48c1-8211-84d29b8c33bb)

Po wybraniu motywu oraz rozmiaru i stylu czcionki, należy kliknąć przycisk `zastosuj ustawienia`, aby wprowadzić zmiany.

![image](https://github.com/edyta01m/Projekt-ZMUM-WMUM/assets/115696466/0c1eb709-74fd-4f1c-8853-349859078fc8)

Druga zakładka zawiera wczytywanie danych. W celu wczytania danych należy kliknąć na napis `wybierz plik csv` a następnie załadować z dysku plik `gold_price_data.csv`.

![image](https://github.com/edyta01m/Projekt-ZMUM-WMUM/assets/115696466/7892a6c6-ab07-4664-b610-5ab6bd9ac42d)

Trzecia zakładka zawiera: 
- panel, w którym możemy ustawić zakres dat, branych do modelu (nie wcześniej niż 1 stycznia 1970r. i nie poźniej niż 13 marca 2020r., gdyż jest to zakres dat dostępnych w zbiorze `gold_price_data.csv`),
- opcję wyboru modelu z rozwijanej listy,
- opcję wybrania daty, dla której zostanie dokonana predykcja (nie wcześniej i nie później niż wspomniany wcześniej zakres dat),
- wykres ceny na przestrzeni czasu (dla wybranego w panelu bocznym zakresu dat),
- predykcję oraz średni błąd bezwzględny modelu dla wybranej w panelu bocznym daty.

![image](https://github.com/edyta01m/Projekt-ZMUM-WMUM/assets/115696466/e6143089-36e2-435b-b307-775af9382b23)

> :warning: **Uwaga**
>
> Narysowanie wykresu oraz policzenie wartości predykcji i błędu może chwilę zająć, należy poczekać.

# Bibliografia
1. https://majerek.quarto.pub/zaawansowane-metody-uczenia-maszynowego/
2. https://dax44-models-deployment.netlify.app/
3. https://www.statsoft.pl/textbook/stathome_stat.html?https%3A%2F%2Fwww.statsoft.pl%2Ftextbook%2Fstsvm.html&fbclid=IwZXh0bgNhZW0CMTAAAR20oG-ca5mnqg1EGMfBi3BxuWdsPKWtFQBPUJJuAIxDdh44C-fhYiD4dU8_aem_Afb0u7HwIbxRElDwT4k7M3arldns9VVbKgCBR50hgJFdhE8Y0T11PF5y9w8NZMeCZxN2T0TzEKXag8Wy_zhCY0gX
4. https://www.statsoft.pl/textbook/stathome_stat.html?https%3A%2F%2Fwww.statsoft.pl%2Ftextbook%2Fstsvm.html&fbclid=IwZXh0bgNhZW0CMTAAAR20oG-ca5mnqg1EGMfBi3BxuWdsPKWtFQBPUJJuAIxDdh44C-fhYiD4dU8_aem_Afb0u7HwIbxRElDwT4k7M3arldns9VVbKgCBR50hgJFdhE8Y0T11PF5y9w8NZMeCZxN2T0TzEKXag8Wy_zhCY0gX
5. https://bootswatch.com/4/
6. https://rstudio.github.io/shinythemes/
7. https://www.cri.agh.edu.pl/uczelnia/tad/inteligencja_obliczeniowa/08%20-%20Uczenie%20-%20pogl%C4%85dowe.pdf
8. https://www.appsilon.com/post/r-shiny-bslib
>>>>>>> f76b19d (Update README.md)
