#!/bin/bash

# Kolory dla lepszej czytelności
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Nvidia Ubuntu Performance Benchmark Installer ===${NC}"

# Sprawdzenie czy skrypt jest uruchomiony z sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Proszę uruchomić instalator z sudo${NC}"
    exit 1
fi

# Sprawdzenie systemu
if ! command -v lsb_release &> /dev/null; then
    echo -e "${RED}To narzędzie wymaga systemu Ubuntu${NC}"
    exit 1
fi

# Instalacja wymaganych pakietów
echo -e "${YELLOW}Instalacja wymaganych pakietów...${NC}"
apt-get update
apt-get install -y sysstat procps nvidia-utils bc curl

# Sprawdzenie czy karta NVIDIA jest obecna
if ! lspci | grep -i nvidia &> /dev/null; then
    echo -e "${RED}UWAGA: Nie wykryto karty NVIDIA${NC}"
    echo -e "${YELLOW}Skrypt może nie działać prawidłowo bez karty NVIDIA${NC}"
    read -p "Czy chcesz kontynuować? (t/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Tt]$ ]]; then
        echo -e "${RED}Instalacja przerwana${NC}"
        exit 1
    fi
fi

# Pobranie skryptu benchmark.sh
echo -e "${YELLOW}Pobieranie skryptu benchmark...${NC}"
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/benchmark.sh -o /usr/local/bin/nvidia-benchmark
chmod +x /usr/local/bin/nvidia-benchmark

# Sprawdzenie instalacji
if [ -f /usr/local/bin/nvidia-benchmark ]; then
    echo -e "${GREEN}Instalacja zakończona pomyślnie!${NC}"
    echo -e "${YELLOW}Użycie:${NC}"
    echo "nvidia-benchmark before  - zbierz dane przed optymalizacją"
    echo "nvidia-benchmark after   - zbierz dane po optymalizacji"
    echo "nvidia-benchmark compare - porównaj zebrane dane"
else
    echo -e "${RED}Błąd podczas instalacji${NC}"
    exit 1
fi

# Sprawdzenie opcjonalnych komponentów
if ! command -v gnuplot &> /dev/null; then
    echo -e "${YELLOW}Sugestia: Zainstaluj gnuplot dla generowania wykresów:${NC}"
    echo "sudo apt-get install gnuplot"
fi

if ! command -v ollama &> /dev/null; then
    echo -e "${YELLOW}Sugestia: Zainstaluj ollama dla testów LLM:${NC}"
    echo "curl https://ollama.ai/install.sh | sh"
fi

echo -e "${GREEN}Gotowe!${NC}"