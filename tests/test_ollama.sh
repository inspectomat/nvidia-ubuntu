#!/bin/bash
# Test suite for Ollama functionality

# Source test utilities
source "$(dirname "$0")/test_settings.sh"

test_ollama_installation() {
    assert_command "command -v ollama" "Checking if Ollama is installed"
}

test_ollama_service() {
    assert_command "systemctl is-active --quiet ollama" "Checking if Ollama service is running"
}

test_gpu_detection() {
    assert_command "nvidia-smi" "Checking NVIDIA GPU detection"
}

test_basic_inference() {
    # Pull test model if not exists
    ollama pull llama2 >/dev/null 2>&1
    
    # Test basic inference
    TEST_PROMPT="What is 2+2?"
    RESPONSE=$(echo "$TEST_PROMPT" | ollama run llama2 2>/dev/null)
    
    if [[ "$RESPONSE" == *"4"* ]]; then
        echo "✓ Basic inference test passed"
        return 0
    else
        echo "✗ Basic inference test failed"
        return 1
    fi
}

# Run tests
run_test test_ollama_installation
run_test test_ollama_service
run_test test_gpu_detection
run_test test_basic_inference
