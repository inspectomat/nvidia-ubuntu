#!/bin/bash

# Kolory dla lepszej czytelności
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Nvidia Ubuntu Performance Benchmark & Optimization Installer ===${NC}"

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

# Sprawdzenie wersji Ubuntu
UBUNTU_VERSION=$(lsb_release -rs)
if [ "$UBUNTU_VERSION" != "24.10" ]; then
    echo -e "${YELLOW}UWAGA: Skrypt jest zoptymalizowany pod Ubuntu 24.10${NC}"
    echo -e "${YELLOW}Aktualna wersja: $UBUNTU_VERSION${NC}"
    read -p "Czy chcesz kontynuować? (t/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Tt]$ ]]; then
        exit 1
    fi
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

# Pobranie skryptów
echo -e "${YELLOW}Pobieranie skryptów...${NC}"
# Benchmark
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/benchmark.sh -o /usr/local/bin/nvidia-benchmark
chmod +x /usr/local/bin/nvidia-benchmark

# Optimize
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/optimize.sh -o /usr/local/bin/nvidia-optimize
chmod +x /usr/local/bin/nvidia-optimize

# Sprawdzenie instalacji
if [ -f /usr/local/bin/nvidia-benchmark ] && [ -f /usr/local/bin/nvidia-optimize ]; then
    echo -e "${GREEN}Instalacja zakończona pomyślnie!${NC}"
    echo -e "${YELLOW}Dostępne narzędzia:${NC}"
    echo "1. nvidia-benchmark:"
    echo "   - nvidia-benchmark before  - zbierz dane przed optymalizacją"
    echo "   - nvidia-benchmark after   - zbierz dane po optymalizacji"
    echo "   - nvidia-benchmark compare - porównaj zebrane dane"
    echo ""
    echo "2. nvidia-optimize:"
    echo "   - sudo nvidia-optimize     - optymalizacja systemu"
    echo ""
    echo -e "${YELLOW}Czy chcesz uruchomić optymalizację systemu teraz? (t/N)${NC}"
    read -p "" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Tt]$ ]]; then
        nvidia-optimize
    fi
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