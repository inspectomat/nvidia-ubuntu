#!/bin/bash
# Test suite for reset-nvidia functionality

# Source test utilities
source "$(dirname "$0")/test_settings.sh"

test_nvidia_dependencies() {
    assert_command "command -v nvidia-smi" "Checking if nvidia-smi is installed"
    assert_command "command -v nvidia-settings" "Checking if nvidia-settings is installed"
}

test_nvidia_gpu_detection() {
    assert_command "nvidia-smi" "Checking if NVIDIA GPU is detected"
}

test_settings_application() {
    # Run reset-nvidia
    sudo ../reset-nvidia.sh
    
    # Verify persistent mode
    PM_STATUS=$(nvidia-smi -q -d PERFORMANCE | grep "Persistence Mode" | awk '{print $4}')
    if [ "$PM_STATUS" = "Enabled" ]; then
        echo "✓ Persistent mode is enabled"
    else
        echo "✗ Persistent mode is not enabled"
        return 1
    fi
    
    # Verify auto boost is disabled
    BOOST_STATUS=$(nvidia-smi -q -d PERFORMANCE | grep "Auto Boost" | awk '{print $4}')
    if [ "$BOOST_STATUS" = "Disabled" ]; then
        echo "✓ Auto boost is disabled"
    else
        echo "✗ Auto boost is not disabled"
        return 1
    fi
    
    # Verify power limit
    POWER_LIMIT=$(nvidia-smi -q -d POWER | grep "Power Limit" | head -n 1 | awk '{print $4}')
    if [ "${POWER_LIMIT%.*}" -eq 115 ]; then
        echo "✓ Power limit is set to 115W"
    else
        echo "✗ Power limit is not set to 115W"
        return 1
    fi
}

test_power_mizer_mode() {
    # Get current PowerMizerMode
    MIZER_MODE=$(nvidia-settings -q "[gpu:0]/GpuPowerMizerMode" | grep "Attribute" | awk '{print $4}' | tr -d '.')
    if [ "$MIZER_MODE" = "1" ]; then
        echo "✓ Power mizer mode is set to maximum performance"
    else
        echo "✗ Power mizer mode is not set to maximum performance"
        return 1
    fi
}

# Run tests
run_test test_nvidia_dependencies
run_test test_nvidia_gpu_detection
run_test test_settings_application
run_test test_power_mizer_mode

echo "All reset-nvidia tests completed"
