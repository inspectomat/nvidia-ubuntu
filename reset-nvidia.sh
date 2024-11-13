#!/bin/bash
# NVIDIA Settings Reset Tool
#
## Description:
#   This script resets NVIDIA GPU settings to optimal values for
#   performance. It configures power management, boost settings,
#   clock speeds, and power limits.
#
## Requirements:
#   - NVIDIA GPU
#   - nvidia-smi
#   - nvidia-settings
#
## Usage:
#   This script must be run with sudo privileges:
#   sudo ./reset-nvidia.sh

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this script with sudo privileges${NC}"
    exit 1
fi

# Check for NVIDIA GPU
check_nvidia() {
    if ! command -v nvidia-smi &> /dev/null; then
        echo -e "${RED}nvidia-smi not found. Is the NVIDIA driver installed?${NC}"
        exit 1
    fi
    
    if ! command -v nvidia-settings &> /dev/null; then
        echo -e "${RED}nvidia-settings not found. Please install nvidia-settings${NC}"
        exit 1
    fi
    
    if ! nvidia-smi &> /dev/null; then
        echo -e "${RED}No NVIDIA GPU detected${NC}"
        exit 1
    fi
}

# Reset NVIDIA settings
reset_settings() {
    echo -e "${YELLOW}Resetting NVIDIA GPU settings...${NC}"
    
    # Enable persistent mode
    nvidia-smi -pm 1
    
    # Disable auto boost
    nvidia-smi --auto-boost-default=0
    
    # Set application clocks
    nvidia-smi -ac 3615,1530
    
    # Set power limit
    nvidia-smi --power-limit=115
    
    # Set power mizer mode to maximum performance
    nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"
}

# Main execution
echo -e "${GREEN}=== NVIDIA Settings Reset Tool ===${NC}"

check_nvidia
reset_settings

echo -e "${GREEN}NVIDIA settings have been reset to optimal values${NC}"
