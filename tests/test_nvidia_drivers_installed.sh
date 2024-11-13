#!/bin/bash

# Test function to check if NVIDIA drivers are installed
test_nvidia_drivers_installed() {
    if nvidia-smi &>/dev/null; then
        echo "NVIDIA drivers are installed"
    else
        echo "ERROR: NVIDIA drivers are not installed"
        exit 1
    fi
}


test_nvidia_drivers_installed