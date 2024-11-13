#!/bin/bash

# Color definitions for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to check if NVIDIA drivers are installed
check_nvidia_drivers() {
    if nvidia-smi &>/dev/null; then
        echo -e "${GREEN}NVIDIA drivers are installed${NC}"
        return 0
    else
        echo -e "${RED}NVIDIA drivers are not installed${NC}"
        return 1
    fi
}

# Function to detect NVIDIA GPU
detect_nvidia_gpu() {
    if ! lspci | grep -i nvidia &> /dev/null; then
        echo -e "${RED}UWAGA: Nie wykryto karty NVIDIA${NC}"
        echo -e "${YELLOW}Skrypt może nie działać prawidłowo bez karty NVIDIA${NC}"
        read -p "Czy chcesz kontynuować? (t/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Tt]$ ]]; then
            echo -e "${RED}Instalacja przerwana${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Wykryto kartę NVIDIA${NC}"
    fi
}

# Function to install NVIDIA drivers
install_nvidia_drivers() {
    echo -e "${YELLOW}Instalacja sterowników NVIDIA...${NC}"
    
    # Update package list
    apt-get update
    
    # Install required packages
    apt-get install -y nvidia-utils
    
    # Install latest NVIDIA drivers
    apt-get install -y nvidia-driver-545
    
    # Install CUDA toolkit if needed
    apt-get install -y nvidia-cuda-toolkit
    
    # Verify installation
    if check_nvidia_drivers; then
        echo -e "${GREEN}Sterowniki NVIDIA zostały pomyślnie zainstalowane${NC}"
        return 0
    else
        echo -e "${RED}Błąd podczas instalacji sterowników NVIDIA${NC}"
        return 1
    fi
}

# Main execution
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Proszę uruchomić skrypt z sudo${NC}"
    exit 1
fi

detect_nvidia_gpu
install_nvidia_drivers
