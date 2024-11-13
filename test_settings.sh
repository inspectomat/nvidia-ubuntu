# Unit test for the selected code block
# Test case: Should not interfere with existing system settings

# Function to check if NVIDIA drivers are installed
function check_nvidia_drivers_installed() {
    if nvidia-smi &>/dev/null; then
        return 0  # NVIDIA drivers are installed
    else
        return 1  # NVIDIA drivers are not installed
    fi
}

# Function to check if NVIDIA settings are configured correctly
function check_nvidia_settings() {
    local expected_power_limit="115"
    local expected_power_mizer_mode="1"

    local actual_power_limit=$(nvidia-smi --query-gpu=0 --format=csv,noheader --gpu-query-power-limit)
    local actual_power_mizer_mode=$(nvidia-settings -q "[gpu:0]/GpuPowerMizerMode" -t)

    if [[ $actual_power_limit == $expected_power_limit && $actual_power_mizer_mode == $expected_power_mizer_mode ]]; then
        return 0  # NVIDIA settings are configured correctly
    else
        return 1  # NVIDIA settings are not configured correctly
    fi
}

# Function to check if CPU settings are configured correctly
function check_cpu_settings() {
    local expected_governor="performance"

    for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        local actual_governor=$(cat $governor)

        if [[ $actual_governor != $expected_governor ]]; then
            return 1  # CPU settings are not configured correctly
        fi
    done

    return 0  # CPU settings are configured correctly
}

# Main test function
function test_settings() {
    # Check if NVIDIA drivers are installed
    if check_nvidia_drivers_installed; then
        echo "NVIDIA drivers are installed"
    else
        echo "NVIDIA drivers are not installed"
        exit 1
    fi

    # Check if NVIDIA settings are configured correctly
    if check_nvidia_settings; then
        echo "NVIDIA settings are configured correctly"
    else
        echo "NVIDIA settings are not configured correctly"
        exit 1
    fi

    # Check if CPU settings are configured correctly
    if check_cpu_settings; then
        echo "CPU settings are configured correctly"
    else
        echo "CPU settings are not configured correctly"
        exit 1
    fi

    echo "All system settings are checked successfully"
}

# Run the main test function
test_settings