#!/bin/bash

# Definicja ścieżek do plików z wynikami
BEFORE_FILE="performance_before.log"
AFTER_FILE="performance_after.log"
COMPARISON_FILE="performance_comparison.txt"

# Funkcja do zbierania danych o wydajności
collect_performance_data() {
    local output_file=$1
    echo "Zbieranie danych wydajnościowych do pliku: $output_file"

    # Utworzenie pliku i dodanie nagłówka z datą
    echo "=== Pomiar wydajności $(date) ===" > "$output_file"
    echo "" >> "$output_file"

    # CPU Info
    echo "=== CPU ===" >> "$output_file"
    echo "Częstotliwość CPU:" >> "$output_file"
    cat /proc/cpuinfo | grep "MHz" >> "$output_file"
    echo "Obciążenie CPU:" >> "$output_file"
    mpstat 1 5 >> "$output_file"

    # Memory Info
    echo -e "\n=== PAMIĘĆ ===" >> "$output_file"
    free -h >> "$output_file"
    echo "SWAP usage:" >> "$output_file"
    swapon --show >> "$output_file"

    # GPU Info
    echo -e "\n=== GPU NVIDIA ===" >> "$output_file"
    nvidia-smi --query-gpu=temperature.gpu,power.draw,clocks.current.graphics,clocks.current.memory,utilization.gpu,utilization.memory --format=csv >> "$output_file"

    # Disk I/O
    echo -e "\n=== DYSK I/O ===" >> "$output_file"
    iostat -x 1 5 >> "$output_file"

    # System Load
    echo -e "\n=== OBCIĄŻENIE SYSTEMU ===" >> "$output_file"
    uptime >> "$output_file"

    # Test wydajności CUDA
    echo -e "\n=== TEST CUDA ===" >> "$output_file"
    # Prosty test CUDA używając nvidia-smi
    nvidia-smi nvlink -gt p >> "$output_file"

    # Test Ollama (jeśli zainstalowane)
    if command -v ollama &> /dev/null; then
        echo -e "\n=== TEST OLLAMA ===" >> "$output_file"
        # Test małego modelu dla benchmarku
        time ollama run phi "What is 2+2?" 2>> "$output_file"
    fi
}

# Funkcja do porównywania wyników
compare_results() {
    echo "Porównanie wyników wydajnościowych" > "$COMPARISON_FILE"
    echo "Data porównania: $(date)" >> "$COMPARISON_FILE"
    echo "========================================" >> "$COMPARISON_FILE"

    # Funkcja pomocnicza do wydobywania wartości
    extract_value() {
        local file=$1
        local pattern=$2
        grep -A 1 "$pattern" "$file" | tail -n 1
    }

    # Porównanie CPU
    echo -e "\nPORÓWNANIE CPU:" >> "$COMPARISON_FILE"
    echo "Przed optymalizacją:" >> "$COMPARISON_FILE"
    extract_value "$BEFORE_FILE" "Obciążenie CPU:" >> "$COMPARISON_FILE"
    echo "Po optymalizacji:" >> "$COMPARISON_FILE"
    extract_value "$AFTER_FILE" "Obciążenie CPU:" >> "$COMPARISON_FILE"

    # Porównanie pamięci
    echo -e "\nPORÓWNANIE PAMIĘCI:" >> "$COMPARISON_FILE"
    echo "Przed optymalizacją:" >> "$COMPARISON_FILE"
    extract_value "$BEFORE_FILE" "=== PAMIĘĆ ===" >> "$COMPARISON_FILE"
    echo "Po optymalizacji:" >> "$COMPARISON_FILE"
    extract_value "$AFTER_FILE" "=== PAMIĘĆ ===" >> "$COMPARISON_FILE"

    # Porównanie GPU
    echo -e "\nPORÓWNANIE GPU:" >> "$COMPARISON_FILE"
    echo "Przed optymalizacją:" >> "$COMPARISON_FILE"
    extract_value "$BEFORE_FILE" "=== GPU NVIDIA ===" >> "$COMPARISON_FILE"
    echo "Po optymalizacji:" >> "$COMPARISON_FILE"
    extract_value "$AFTER_FILE" "=== GPU NVIDIA ===" >> "$COMPARISON_FILE"

    # Analiza procentowa zmian (jeśli możliwe)
    echo -e "\nANALIZA ZMIAN:" >> "$COMPARISON_FILE"

    # Funkcja do obliczania procentowej zmiany
    calculate_percentage_change() {
        local before=$1
        local after=$2
        if [[ $before =~ ^[0-9]+(\.[0-9]+)?$ ]] && [[ $after =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            local change=$(echo "scale=2; (($after - $before) / $before) * 100" | bc)
            echo "$change%"
        else
            echo "Nie można obliczyć zmiany procentowej"
        fi
    }

    # Przykład analizy dla GPU
    local gpu_before=$(extract_value "$BEFORE_FILE" "utilization.gpu" | cut -d',' -f5 | tr -d '%')
    local gpu_after=$(extract_value "$AFTER_FILE" "utilization.gpu" | cut -d',' -f5 | tr -d '%')
    echo "Zmiana wykorzystania GPU: $(calculate_percentage_change $gpu_before $gpu_after)" >> "$COMPARISON_FILE"

    # Wizualizacja wyników (wymaga gnuplot)
    if command -v gnuplot &> /dev/null; then
        create_performance_graphs
    fi
}

# Funkcja do tworzenia wykresów
create_performance_graphs() {
    # Skrypt gnuplot do generowania wykresów
    cat > plot_performance.gnuplot << EOF
set terminal png size 800,600
set output 'performance_comparison.png'
set title 'Porównanie wydajności przed i po optymalizacji'
set style data histograms
set style fill solid
set boxwidth 0.5
plot 'performance_data.tmp' using 2:xtic(1) title 'Przed' fill pattern 1, \
     '' using 3 title 'Po' fill pattern 2
EOF

    # Przygotowanie danych do wykresu
    echo "Metryka Przed Po" > performance_data.tmp
    echo "GPU_Util $(extract_value "$BEFORE_FILE" "utilization.gpu" | cut -d',' -f5 | tr -d '%') $(extract_value "$AFTER_FILE" "utilization.gpu" | cut -d',' -f5 | tr -d '%')" >> performance_data.tmp

    # Generowanie wykresu
    gnuplot plot_performance.gnuplot

    # Sprzątanie
    rm performance_data.tmp plot_performance.gnuplot
}

# Główna funkcja wykonawcza
main() {
    case "$1" in
        "before")
            collect_performance_data "$BEFORE_FILE"
            echo "Zebrano dane przed optymalizacją"
            ;;
        "after")
            collect_performance_data "$AFTER_FILE"
            echo "Zebrano dane po optymalizacji"
            ;;
        "compare")
            if [[ -f "$BEFORE_FILE" && -f "$AFTER_FILE" ]]; then
                compare_results
                echo "Porównanie zostało zapisane w pliku $COMPARISON_FILE"
                if [[ -f "performance_comparison.png" ]]; then
                    echo "Wygenerowano wykres: performance_comparison.png"
                fi
            else
                echo "Błąd: Brak plików z danymi do porównania"
                exit 1
            fi
            ;;
        *)
            echo "Użycie: $0 {before|after|compare}"
            echo "  before  - zbierz dane przed optymalizacją"
            echo "  after   - zbierz dane po optymalizacji"
            echo "  compare - porównaj zebrane dane"
            exit 1
            ;;
    esac
}

# Sprawdzenie wymaganych narzędzi
for cmd in mpstat free nvidia-smi iostat bc; do
    if ! command -v $cmd &> /dev/null; then
        echo "Błąd: Brak wymaganego narzędzia: $cmd"
        echo "Zainstaluj pakiety: sysstat, procps, nvidia-utils, sysstat, bc"
        exit 1
    fi
done

# Uruchomienie głównej funkcji
main "$@"