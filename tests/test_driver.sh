#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Counter for tests
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
print_test_result() {
    local test_name=$1
    local result=$2
    if [ $result -eq 0 ]; then
        echo -e "${GREEN}✓ $test_name passed${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ $test_name failed${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Test 1: Check if driver.sh exists
test_driver_exists() {
    echo "Testing if driver.sh exists..."
    if [ -f "/app/driver.sh" ]; then
        return 0
    else
        return 1
    fi
}

# Test 2: Check if driver.sh is executable
test_driver_executable() {
    echo "Testing if driver.sh is executable..."
    if [ -x "/app/driver.sh" ]; then
        return 0
    else
        return 1
    fi
}

# Test 3: Mock NVIDIA GPU detection
test_gpu_detection() {
    echo "Testing GPU detection with mocked lspci output..."
    # Create mock lspci function
    function lspci() {
        echo "01:00.0 VGA compatible controller: NVIDIA Corporation Device 2684 (rev a1)"
    }
    export -f lspci
    
    # Source driver.sh to access functions
    source /app/driver.sh
    
    # Call detect_nvidia_gpu function
    if detect_nvidia_gpu > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Test 4: Test driver installation function structure
test_driver_installation_function() {
    echo "Testing driver installation function structure..."
    if grep -q "install_nvidia_drivers()" /app/driver.sh; then
        return 0
    else
        return 1
    fi
}

# Run all tests
echo -e "${YELLOW}Starting driver.sh tests...${NC}"

# Run individual tests
test_driver_exists
print_test_result "Driver existence" $?

test_driver_executable
print_test_result "Driver executable" $?

test_gpu_detection
print_test_result "GPU detection" $?

test_driver_installation_function
print_test_result "Installation function" $?

# Print summary
echo -e "\n${YELLOW}Test Summary:${NC}"
echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
echo -e "${RED}Tests failed: $TESTS_FAILED${NC}"

# Exit with failure if any tests failed
if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
