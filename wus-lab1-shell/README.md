# wus-lab1

## Instrukcja uruchomienia
W celu uruchominia skryptu należy wykonać następujące kroki
- Uruchomić maszyny wirtualne 
- Otworzyć odpowiednie porty (koniguracja 1, 2 i 4 wymagają otworzenia portu 80 ma maszynie z loadbalancerm, dodatkowo konfiguracja 1 wymaga otworzenia odpowiedniego portu dla backendu)
- pobrać projekty spring petclinic na maszynę
- wprowadzić informacje o maszynach do pliku konfiguracyjnego config
- nadać skryptom prawa do wykonywania
- uruchomoć skrypt ./deploy-all.sh (można też niezależnie uruchomamiać deployment frontendu, backendu i bazy danych)

## Budowa pliku konfiguracyjnego CONFIG
Każda linia w pliku oznacza konfigurację jednej maszyny.Kolejne elementy konfiguracji maszyny to słowa rozdzielane spacjami. Elementy konfiguracji są podawane w następującej kolejności:
 - słowo kluczowe - są to frontend, backend, nginx i database - w konfiguracji 2 i 4 backend może występować wielokrotnie - poszczególne wiersze oznaczają kolejne maszyny zawierające backend (ilość replik jest dowolna)
 - ip publiczne maszyny
 - port na jakim nasłuchuje konkretny element systemu
 - ścieżka na lokalnym komputerze do folderu z projketem (np. ./spring-petclinic-rest dla frontendu jeśli znajduje się w tym samym katalogu co skrypt) - projekty trzeba pobrać ręcznie
 - ip maszyny w sieci az
 - nazwa resource-grupy
 - nazwa maszyny wirtualnej
 - nazwa użytkownika na maszynie

W katalogu ze skryptami występuje jeszcze folder resources zawarte są w nim pliki pomocnicze dla sktuptów np. szablon dla pliku konfiguracyjnego nginx wypełnianego przez skrypt na bazie plików konfiguracyjnych

