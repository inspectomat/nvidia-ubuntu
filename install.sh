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
apt-get install -y sysstat procps bc curl

# Install NVIDIA drivers using driver.sh
./driver.sh

# Download scripts
echo -e "${YELLOW}Pobieranie skryptów...${NC}"
# Benchmark
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/benchmark.sh -o /usr/local/bin/nvidia-benchmark
chmod +x /usr/local/bin/nvidia-benchmark

# Optimize
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/optimize.sh -o /usr/local/bin/nvidia-optimize
chmod +x /usr/local/bin/nvidia-optimize

# Check installation
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

echo "Tworzenie skryptu monitorującego..."
cat > /usr/local/bin/monitor-llm << EOF
#!/bin/bash
tmux new-session -d -s monitor
tmux split-window -h
tmux send-keys -t 0 'htop' C-m
tmux send-keys -t 1 'nvtop' C-m
tmux attach-session -t monitor
EOF

chmod +x /usr/local/bin/monitor-llm

echo "Tworzenie skryptu do szybkiego resetu ustawień NVIDIA"
cat > /usr/local/bin/reset-nvidia << EOF
#!/bin/bash
nvidia-smi -pm 1
nvidia-smi --auto-boost-default=0
nvidia-smi -ac 3615,1530
nvidia-smi --power-limit=115
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"
echo "Ustawienia NVIDIA zresetowane do optymalnych wartości"
EOF

chmod +x /usr/local/bin/reset-nvidia

# Check optional components
if ! command -v gnuplot &> /dev/null; then
    echo -e "${YELLOW}Sugestia: Zainstaluj gnuplot dla generowania wykresów:${NC}"
    echo "sudo apt-get install gnuplot"
fi

if ! command -v ollama &> /dev/null; then
    echo -e "${YELLOW}Sugestia: Zainstaluj ollama dla testów LLM:${NC}"
    echo "curl https://ollama.ai/install.sh | sh"
fi

echo -e "${GREEN}Gotowe!${NC}"
