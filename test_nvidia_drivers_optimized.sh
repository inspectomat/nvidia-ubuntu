#!/bin/bash
# Test function to check if NVIDIA drivers are optimized
test_nvidia_drivers_optimized() {
    # Check NVIDIA driver version
    if nvidia-smi | grep "Driver Version: 545." &>/dev/null; then
        echo "NVIDIA drivers are optimized"
    else
        echo "ERROR: NVIDIA drivers are not optimized"
        exit 1
    fi

    # Check NVIDIA settings
    if nvidia-smi -q -d SUPPORTED_CLOCKS | grep "1530 MHz" &>/dev/null &&
       nvidia-smi -q -d SUPPORTED_MEMORY_CLOCK | grep "3615 MHz" &>/dev/null &&
       nvidia-smi -q -d PERFORMANCE_STATE | grep "P0" &>/dev/null; then
        echo "NVIDIA settings are optimized"
    else
        echo "ERROR: NVIDIA settings are not optimized"
        exit 1
    fi
}

test_nvidia_drivers_optimized