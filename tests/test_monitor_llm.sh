#!/bin/bash
# Test suite for monitor-llm functionality

# Source test utilities
source "$(dirname "$0")/test_settings.sh"

test_dependencies() {
    assert_command "command -v tmux" "Checking if tmux is installed"
    assert_command "command -v htop" "Checking if htop is installed"
    assert_command "command -v nvtop" "Checking if nvtop is installed"
}

test_tmux_session_management() {
    # Start monitor-llm in background
    ../monitor-llm.sh &
    PID=$!
    
    # Give it time to start
    sleep 2
    
    # Check if tmux session exists
    assert_command "tmux has-session -t monitor" "Checking if monitor session exists"
    
    # Check if both panes are created
    PANE_COUNT=$(tmux list-panes -t monitor | wc -l)
    if [ "$PANE_COUNT" -eq 2 ]; then
        echo "✓ Correct number of panes created"
    else
        echo "✗ Expected 2 panes, got $PANE_COUNT"
        return 1
    fi
    
    # Cleanup
    tmux kill-session -t monitor
    kill $PID 2>/dev/null
}

test_process_running() {
    # Start monitor-llm in background
    ../monitor-llm.sh &
    PID=$!
    
    # Give it time to start
    sleep 2
    
    # Check if htop and nvtop are running
    assert_command "pgrep htop" "Checking if htop is running"
    assert_command "pgrep nvtop" "Checking if nvtop is running"
    
    # Cleanup
    tmux kill-session -t monitor
    kill $PID 2>/dev/null
}

# Run tests
run_test test_dependencies
run_test test_tmux_session_management
run_test test_process_running

echo "All monitor-llm tests completed"
