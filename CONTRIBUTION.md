# Contribution Guidelines

## Jak zacząć

1. Sklonuj repozytorium
2. Utwórz nowy branch dla swojej funkcjonalności
3. Wprowadź zmiany
4. Wyślij Pull Request

## Środowisko deweloperskie

1. Utwórz wirtualne środowisko Python:
```bash
python -m venv .venv
source .venv/bin/activate
```

2. Zainstaluj zależności deweloperskie:
```bash
pip install -r requirements.txt -r requirements-dev.txt
```

## Standardy kodowania

1. Kod Python:
   - Zgodność z PEP 8
   - Docstringi dla wszystkich funkcji i klas
   - Type hints dla argumentów funkcji
   - Testy jednostkowe dla nowej funkcjonalności

2. Dokumentacja:
   - Aktualizacja README.md dla nowych funkcji
   - Dokumentacja kodu w języku polskim
   - Komentarze w kodzie w języku angielskim

## Proces Pull Request

1. Upewnij się, że wszystkie testy przechodzą
2. Zaktualizuj dokumentację
3. Dodaj wpis do CHANGELOG.md
4. Wyślij Pull Request z opisem zmian

## Zgłaszanie błędów

1. Sprawdź czy błąd nie został już zgłoszony
2. Użyj szablonu Issue do zgłoszenia błędu
3. Dołącz:
   - Kroki do reprodukcji
   - Oczekiwane zachowanie
   - Aktualne zachowanie
   - Logi i screenshoty (jeśli dostępne)

## Konwencje commitów

Format: `typ(zakres): opis`

Typy:
- feat: nowa funkcjonalność
- fix: naprawa błędu
- docs: zmiany w dokumentacji
- style: formatowanie, brakujące średniki itp.
- refactor: refaktoryzacja kodu
- test: dodanie testów
- chore: aktualizacja zadań grunt itp.

## Wskazówki

1. Testowanie:
   - Napisz testy przed implementacją (TDD)
   - Utrzymuj pokrycie kodu testami
   - Używaj pytest dla testów

2. Dokumentacja:
   - Aktualizuj dokumentację wraz z kodem
   - Używaj przykładów w dokumentacji
   - Dokumentuj wszystkie publiczne API

3. Kod:
   - Przestrzegaj zasady DRY (Don't Repeat Yourself)
   - Pisz czytelny i samo-dokumentujący się kod
   - Używaj meaningful names dla zmiennych i funkcji

## Licencja

Upewnij się, że rozumiesz licencję projektu przed kontrybucją.
