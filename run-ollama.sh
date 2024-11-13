#!/bin/bash
# Ollama Runner for NVIDIA GPU Testing
#
## Description:
#   This script manages Ollama installation and running for LLM testing
#   on NVIDIA GPUs. It provides functionality to install Ollama,
#   verify GPU support, and run basic LLM tests.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this script with sudo${NC}"
    exit 1
fi

# Function to check if Ollama is installed
check_ollama() {
    if ! command -v ollama &> /dev/null; then
        echo -e "${YELLOW}Ollama not found. Installing...${NC}"
        curl https://ollama.ai/install.sh | sh
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to install Ollama${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Ollama is already installed${NC}"
    fi
}

# Function to verify NVIDIA GPU support
verify_gpu() {
    if ! nvidia-smi &> /dev/null; then
        echo -e "${RED}NVIDIA GPU not detected${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}NVIDIA GPU detected${NC}"
    nvidia-smi
}

# Function to run basic LLM test
test_llm() {
    echo -e "${YELLOW}Running basic LLM test...${NC}"
    # Pull a small model for testing
    ollama pull llama2
    
    # Run a simple inference test
    echo 'Testing GPU inference...'
    echo "What is the capital of France?" | ollama run llama2
}

# Main execution
echo -e "${GREEN}=== Ollama GPU Test Runner ===${NC}"

check_ollama
verify_gpu
test_llm

echo -e "${GREEN}Ollama test completed successfully${NC}"
