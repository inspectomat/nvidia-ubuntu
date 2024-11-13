#!/bin/bash
# Monitor LLM System Resources
#
## Description:
#   This script provides a split-screen monitoring interface using tmux
#   to display system resources (htop) and NVIDIA GPU usage (nvtop)
#   simultaneously. Useful for monitoring system performance during
#   LLM operations.
#
## Requirements:
#   - tmux
#   - htop
#   - nvtop
#
## Usage:
#   ./monitor-llm.sh

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v tmux &> /dev/null; then
        missing_deps+=("tmux")
    fi
    if ! command -v htop &> /dev/null; then
        missing_deps+=("htop")
    fi
    if ! command -v nvtop &> /dev/null; then
        missing_deps+=("nvtop")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}Missing dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Please install missing dependencies:${NC}"
        echo "sudo apt-get install ${missing_deps[*]}"
        exit 1
    fi
}

# Kill existing monitor session if it exists
cleanup_existing_session() {
    if tmux has-session -t monitor 2>/dev/null; then
        tmux kill-session -t monitor
    fi
}

# Start monitoring
start_monitoring() {
    tmux new-session -d -s monitor
    tmux split-window -h
    tmux send-keys -t 0 'htop' C-m
    tmux send-keys -t 1 'nvtop' C-m
    tmux attach-session -t monitor
}

# Main execution
echo -e "${GREEN}=== LLM System Resource Monitor ===${NC}"

check_dependencies
cleanup_existing_session
start_monitoring
