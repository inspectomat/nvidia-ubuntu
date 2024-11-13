# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2024-03-21

### Changed
- Reorganized test structure:
  - Moved all test files to tests/ directory
  - Updated Dockerfile.test to handle new test structure
  - Updated test paths in docker-compose.test.yml
- Improved script organization:
  - Extracted monitor-llm to standalone script
  - Extracted reset-nvidia to standalone script
  - Updated install.sh to handle standalone scripts

### Added
- New test files:
  - tests/test_monitor_llm.sh for monitoring functionality
  - tests/test_reset_nvidia.sh for GPU settings
  - tests/test_ollama.sh for LLM functionality
- Enhanced documentation:
  - Updated README.md with new test structure
  - Added test directory layout documentation
  - Improved test execution instructions

### Fixed
- Test environment setup in Dockerfile.test
- Dependencies installation in test environment
- Test file permissions handling

## [2.1.0] - 2024-11-13

### Added
- Comprehensive test documentation:
  - Unit tests for all main tools:
    - nvidia-driver-install tests
    - nvidia-benchmark tests
    - nvidia-optimize tests
    - monitor-llm tests
    - reset-nvidia tests
  - Docker-based test environment setup
  - Integration test suite
- Test automation scripts:
  - run_tests.sh for executing all tests
  - Individual test files for each component

### Changed
- Updated README.md with detailed testing information
- Enhanced installation script documentation
- Added test requirements and setup instructions

## [2.0.0] - 2024-11-13

### Changed
- Completely restructured README.md for better readability
- Added emoji indicators for clearer section organization
- Improved installation instructions with step-by-step guidance
- Enhanced tool usage documentation with explicit examples
- Added detailed explanations for beginners
- Reorganized content to follow a logical progression

### Added
- New sections in README.md:
  - Quick Start guide with installation options
  - Detailed tool descriptions
  - Clear output file documentation
  - Important notes and warnings
  - Comprehensive system requirements
  - Step-by-step optimization guide

## [1.0.0] - 2024-11-13

### Added
- Initial release
- Benchmark script for system performance testing
- Optimization script for NVIDIA GPU (RTX 4060)
- Installation script with automatic dependency handling
- System monitoring and management tools
- CUDA performance testing capabilities
- LLM workload optimization features
- Automatic NVIDIA driver installation (version 545)
- SWAP configuration (110GB for LLM)
- Kernel parameter optimization
- Performance comparison tools

### Features
- CPU frequency and load monitoring
- Memory usage and SWAP status tracking
- NVIDIA GPU metrics collection
- Disk I/O performance measurement
- System load analysis
- CUDA performance testing
- Optional Ollama LLM performance testing
- Performance comparison reporting
- Visual graph generation (with gnuplot)

### Tools
- `run-ollama`: Optimized Ollama launcher
- `monitor-llm`: System resource monitoring
- `reset-nvidia`: NVIDIA settings reset utility
- `nvidia-benchmark`: Performance testing suite
