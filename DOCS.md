

1. Funkcję `install_nvidia_drivers`, która:
   - Usuwa stare sterowniki
   - Blokuje sterownik nouveau
   - Instaluje najnowsze sterowniki NVIDIA (545)
   - Instaluje CUDA Toolkit
   - Weryfikuje instalację

2. Dodatkowe optymalizacje dla RTX 4060:
   - Ustawienie limitu mocy na 115W
   - Konfiguracja trybu maksymalnej wydajności
   - Optymalizacja cache'u CUDA

3. Nowy skrypt `reset-nvidia` do szybkiego przywracania optymalnych ustawień karty

Aby użyć skryptu:
```bash
chmod +x optimize.sh
sudo ./optimize.sh
```

WAŻNE UWAGI:
1. Zrób backup systemu przed uruchomieniem
2. Po instalacji WYMAGANY jest restart
3. Jeśli masz problemy z ekranem po instalacji, możesz użyć Ctrl+Alt+F1 aby przejść do konsoli
4. W przypadku problemów sprawdź logi: `journalctl -xe`


---


1. Funkcję `install_nvidia_drivers`, która:
   - Usuwa stare sterowniki
   - Blokuje sterownik nouveau
   - Instaluje najnowsze sterowniki NVIDIA (545)
   - Instaluje CUDA Toolkit
   - Weryfikuje instalację

2. Dodatkowe optymalizacje dla RTX 4060:
   - Ustawienie limitu mocy na 115W
   - Konfiguracja trybu maksymalnej wydajności
   - Optymalizacja cache'u CUDA

3. Nowy skrypt `reset-nvidia` do szybkiego przywracania optymalnych ustawień karty

Aby użyć skryptu:
```bash
chmod +x optimize.sh
sudo ./optimize.sh
```

WAŻNE UWAGI:
1. Zrób backup systemu przed uruchomieniem
2. Po instalacji WYMAGANY jest restart
3. Jeśli masz problemy z ekranem po instalacji, możesz użyć Ctrl+Alt+F1 aby przejść do konsoli
4. W przypadku problemów sprawdź logi: `journalctl -xe`




---



Stworzyłem skrypt do kompleksowego testowania wydajności. Oto jak go używać:

1. Nadaj uprawnienia wykonywania:
```bash
chmod +x benchmark.sh
```

2. Uruchom testy przed optymalizacją:
```bash
sudo ./benchmark.sh before
```

3. Wykonaj optymalizację systemu (używając wcześniejszego skryptu)

4. Uruchom testy po optymalizacji:
```bash
sudo ./benchmark.sh after
```

5. Porównaj wyniki:
```bash
sudo ./benchmark.sh compare
```

Skrypt:
1. Zbiera dane o:
   - Wydajności CPU
   - Wykorzystaniu pamięci i SWAP
   - Parametrach GPU (temperatura, taktowanie, wykorzystanie)
   - Wydajności I/O dysku
   - Ogólnym obciążeniu systemu
   - Wydajności CUDA
   - Czasie wykonania prostego testu Ollama

2. Tworzy szczegółowe porównanie w pliku tekstowym

3. Generuje wykres porównawczy (jeśli zainstalowany jest gnuplot)

Wymagania:
```bash
sudo apt install sysstat procps nvidia-utils bc gnuplot
```

Pliki wyjściowe:
- `performance_before.log` - dane przed optymalizacją
- `performance_after.log` - dane po optymalizacji
- `performance_comparison.txt` - analiza porównawcza
- `performance_comparison.png` - wykres (opcjonalnie)

