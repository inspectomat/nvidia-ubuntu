#!/bin/bash
# Test case: Should support different GPU models and configurations
# Test steps:
# 1. Check if the script is running as root
# 2. Install NVIDIA drivers for different GPU models
# 3. Verify the installation of NVIDIA drivers
# 4. Verify the status of NVIDIA drivers using nvidia-smi

# Test function: test_ubuntu_llm_optimization
test_ubuntu_llm_optimization() {
    # Step 1: Check if the script is running as root
    if [ "$EUID" -ne 0 ]; then
        echo "Test failed: The script should be run as root"
        return 1
    fi

    # Step 2: Install NVIDIA drivers for different GPU models
    # Example: Install NVIDIA drivers for RTX 4060
    install_nvidia_drivers() {
        # Add the GPU PPA repository
        add-apt-repository -y ppa:graphics-drivers/ppa

        # Update the package list
        apt update

        # Install the NVIDIA driver and CUDA Toolkit
        apt install -y nvidia-driver-545 nvidia-dkms-545 nvidia-cuda-toolkit

        # Reboot the system
        reboot
    }

    # Call the function to install NVIDIA drivers
    install_nvidia_drivers

    # Step 3: Verify the installation of NVIDIA drivers
    if ! command -v nvidia-smi &> /dev/null; then
        echo "Test failed: NVIDIA drivers are not installed"
        return 1
    fi

    # Step 4: Verify the status of NVIDIA drivers using nvidia-smi
    if ! nvidia-smi &>/dev/null; then
        echo "Test failed: NVIDIA drivers are not running"
        return 1
    fi

    # Check the GPU model and driver version
    GPU_MODEL=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader)
    DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)

    echo "Test passed: NVIDIA drivers are installed for GPU model: $GPU_MODEL, driver version: $DRIVER_VERSION"
}

# Run the unit test
test_ubuntu_llm_optimization
