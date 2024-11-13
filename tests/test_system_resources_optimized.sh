#!/bin/bash

# Test function to check if system resources are optimized
test_system_resources_optimized() {
    # Check system parameters
    if grep "vm.swappiness = 10" /etc/sysctl.conf &>/dev/null &&
       grep "vm.vfs_cache_pressure = 50" /etc/sysctl.conf &>/dev/null &&
       grep "vm.dirty_ratio = 60" /etc/sysctl.conf &>/dev/null &&
       grep "vm.dirty_background_ratio = 30" /etc/sysctl.conf &>/dev/null; then
        echo "System parameters are optimized"
    else
        echo "ERROR: System parameters are not optimized"
        exit 1
    fi

    # Check CPU governor
    if grep "performance" /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null; then
        echo "CPU governor is optimized"
    else
        echo "ERROR: CPU governor is not optimized"
        exit 1
    fi
}

# Run the test functions
test_system_resources_optimized