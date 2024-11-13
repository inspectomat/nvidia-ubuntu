# Nvidia Ubuntu Performance Benchmark

Script for benchmarking system performance on Ubuntu with NVIDIA GPU.

## Quick Install

One-line installation:
```bash
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/install.sh | sudo bash
```
or using wget:
```bash
wget -qO- https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/install.sh | sudo bash
```

## Manual Installation

Clone the repository:
```bash
git clone https://github.com/inspectomat/nvidia-ubuntu.git
cd nvidia-ubuntu
chmod +x benchmark.sh
```

## Requirements

The installer will automatically install these dependencies, but if you're installing manually, you need:
```bash
sudo apt-get update
sudo apt-get install sysstat procps nvidia-utils bc
```

Optional features:
- `ollama` - for LLM performance testing
- `gnuplot` - for generating performance graphs

## Usage

The script has three main modes:

1. Collect performance data before optimization:
```bash
nvidia-benchmark before
```

2. Collect performance data after optimization:
```bash
nvidia-benchmark after
```

3. Compare the results:
```bash
nvidia-benchmark compare
```

## Features

Collects and analyzes:
- CPU frequency and load
- Memory usage and SWAP status
- NVIDIA GPU metrics
- Disk I/O performance
- System load
- CUDA performance
- Optional Ollama LLM test

For more details, visit the [GitHub repository](https://github.com/inspectomat/nvidia-ubuntu).

## Features

The script collects and analyzes:
- CPU frequency and load
- Memory usage and SWAP status
- NVIDIA GPU metrics (temperature, power draw, clock speeds, utilization)
- Disk I/O performance
- System load
- CUDA performance via nvlink test
- Optional Ollama LLM performance test

## Output Files

The script generates the following files:
- `performance_before.log` - Performance metrics before optimization
- `performance_after.log` - Performance metrics after optimization
- `performance_comparison.txt` - Detailed comparison of before/after metrics
- `performance_comparison.png` - Visual graph comparison (if gnuplot is installed)

## Example Output

The comparison file includes:
- CPU load comparison
- Memory usage analysis
- GPU utilization changes
- Percentage changes in key metrics
- Visual performance graphs (if gnuplot is installed)


# Nvidia Ubuntu Performance Benchmark & Optimization

Scripts for optimizing and benchmarking system performance on Ubuntu with NVIDIA GPU (optimized for RTX 4060).

## Quick Install

One-line installation and optimization:
```bash
# Install benchmark tools
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/install.sh | sudo bash

# Run system optimization (for RTX 4060)
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/optimize.sh | sudo bash
```

## What it does

### Optimization Script
- Installs latest NVIDIA drivers (545)
- Configures SWAP (110GB for LLM)
- Optimizes kernel parameters
- Sets up NVIDIA GPU for maximum performance
- Creates monitoring and management tools
- Optimizes system for LLM workloads

### Benchmark Script
- Measures system performance
- Monitors CPU, Memory, GPU usage
- Tests CUDA performance
- Generates comparison reports

## Requirements

- Ubuntu 24.10
- NVIDIA GPU (optimized for RTX 4060)
- Root privileges

## Usage

### Optimization
```bash
# Run full system optimization
sudo nvidia-optimize

# Reset NVIDIA settings to optimal values
reset-nvidia

# Monitor system resources
monitor-llm
```

### Benchmarking
```bash
# Before optimization
nvidia-benchmark before

# After optimization
nvidia-benchmark after

# Compare results
nvidia-benchmark compare
```

## Created Tools

The optimization script creates several useful tools:

1. `run-ollama`: Optimized Ollama launcher
2. `monitor-llm`: System monitoring tool (htop + nvtop)
3. `reset-nvidia`: Quick NVIDIA settings reset
4. `nvidia-benchmark`: Performance testing tool

## Notes

- Backup your system before running optimization
- The script is optimized for RTX 4060
- SWAP size is set to 110GB for Llama 3.2 Vision
- System restart required after optimization

## Support

For issues and contributions, visit the [GitHub repository](https://github.com/inspectomat/nvidia-ubuntu).



## License

Apache 2 License

## Contributing

Feel free to open issues or submit pull requests with improvements.



