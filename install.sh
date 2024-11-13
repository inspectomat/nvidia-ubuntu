#!/bin/bash
# Nvidia Ubuntu Performance Benchmark & Optimization Installer
#
## Description:
#   This script installs and sets up tools for benchmarking and
#   optimizing NVIDIA GPU performance on Ubuntu systems. It checks
#   system requirements, installs necessary packages, downloads
#   benchmark and optimization scripts, and creates additional
#   utility scripts for monitoring and resetting NVIDIA settings.
#
## Usage:
#   This script must be run with sudo privileges:
#   sudo ./install.sh
#
## Requirements:
#   - Ubuntu operating system (optimized for version 24.10)
#   - NVIDIA GPU (recommended, but not strictly required)
#   - sudo privileges
#
## Installed Tools:
#   - nvidia-benchmark: For collecting performance data
#   - nvidia-optimize: For system optimization
#   - monitor-llm: For monitoring system resources
#   - reset-nvidia: For resetting NVIDIA settings to optimal values
#
## Optional Components:
#   - gnuplot: For generating graphs
#   - ollama: For LLM tests
#
## Return Value:
#   0 on successful installation
#   1 on error or user cancellation

# Color definitions for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Nvidia Ubuntu Performance Benchmark & Optimization Installer ===${NC}"

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Proszę uruchomić instalator z sudo${NC}"
    exit 1
fi

# Check system
if ! command -v lsb_release &> /dev/null; then
    echo -e "${RED}To narzędzie wymaga systemu Ubuntu${NC}"
    exit 1
fi

# Check Ubuntu version
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

# Install required packages
echo -e "${YELLOW}Instalacja wymaganych pakietów...${NC}"
apt-get update
apt-get install -y sysstat procps bc curl tmux htop nvtop nvidia-settings


# Download scripts
echo -e "${YELLOW}Pobieranie skryptów...${NC}"

# Install NVIDIA drivers using driver.sh
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/driver.sh -o /usr/local/bin/nvidia-driver-install
chmod +x /usr/local/bin/nvidia-driver-install

# Benchmark
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/benchmark.sh -o /usr/local/bin/nvidia-benchmark
chmod +x /usr/local/bin/nvidia-benchmark

# Optimize
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/optimize.sh -o /usr/local/bin/nvidia-optimize
chmod +x /usr/local/bin/nvidia-optimize

# Install monitor-llm
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/monitor-llm.sh -o /usr/local/bin/monitor-llm
chmod +x /usr/local/bin/monitor-llm

# Install reset-nvidia
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/reset-nvidia.sh -o /usr/local/bin/reset-nvidia
chmod +x /usr/local/bin/reset-nvidia

# Check installation
if [ -f /usr/local/bin/nvidia-benchmark ] && [ -f /usr/local/bin/nvidia-optimize ] && \
   [ -f /usr/local/bin/monitor-llm ] && [ -f /usr/local/bin/reset-nvidia ]; then
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
    echo "3. monitor-llm:"
    echo "   - monitor-llm             - monitorowanie zasobów systemu"
    echo ""
    echo "4. reset-nvidia:"
    echo "   - sudo reset-nvidia       - reset ustawień NVIDIA do optymalnych wartości"
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

# Check optional components
if ! command -v gnuplot &> /dev/null; then
    echo -e "${YELLOW}Sugestia: Zainstaluj gnuplot dla generowania wykresów:${NC}"
    echo "sudo apt-get install gnuplot"
fi

if ! command -v ollama &> /dev/null; then
    echo -e "${YELLOW}Sugestia: Zainstaluj ollama dla testów LLM:${NC}"
    echo "curl https://ollama.ai/install.sh | sh"
fi

nvidia-driver-install

echo -e "${GREEN}Gotowe!${NC}"

