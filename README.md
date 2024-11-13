# NVIDIA Ubuntu Performance Suite v2.0.0

A beginner-friendly toolkit for optimizing and benchmarking Ubuntu systems with NVIDIA GPUs. This suite is specifically optimized for RTX 4060 and includes tools for system optimization, performance testing, and monitoring.

## 🚀 Quick Start

### Option 1: Automatic Installation (Recommended for Beginners)
```bash
# Install everything with one command:
curl -sSL https://raw.githubusercontent.com/inspectomat/nvidia-ubuntu/main/install.sh | sudo bash
```

### Option 2: Manual Installation
```bash
# 1. Clone the repository
git clone https://github.com/inspectomat/nvidia-ubuntu.git

# 2. Enter the directory
cd nvidia-ubuntu

# 3. Make scripts executable
chmod +x *.sh
```

## 📋 Requirements

- Ubuntu 24.10
- NVIDIA GPU (optimized for RTX 4060)
- Root/sudo privileges

### Required Packages
The installer will automatically handle these, but for manual installation:
```bash
sudo apt-get update
sudo apt-get install sysstat procps nvidia-utils bc
```

### Optional Packages
- `ollama`: Required for LLM performance testing
- `gnuplot`: Required for generating performance graphs

## 🛠️ Usage

This suite provides several easy-to-use tools:

1. **nvidia-benchmark**: Test system performance
   ```bash
   # Test performance before optimization
   nvidia-benchmark before
   
   nvidia-driver-install

   nvidia-optimize
   
   # Test performance after optimization
   nvidia-benchmark after
   
   # Compare results
   nvidia-benchmark compare
   ```

2. **run-ollama**: Launch Ollama with optimized settings
   ```bash
   run-ollama
   ```

3. **monitor-llm**: Watch system resources in real-time
   ```bash
   monitor-llm
   ```

4. **reset-nvidia**: Reset NVIDIA settings to optimal values
   ```bash
   reset-nvidia
   ```

## 📊 What Gets Measured

The benchmark tool tracks:
- CPU performance (frequency and load)
- Memory usage
- GPU metrics (temperature, power, speed)
- Disk performance
- CUDA capabilities
- LLM performance (optional)

## 📈 Output Files

After running benchmarks, you'll find:
- `performance_before.log`: Initial performance data
- `performance_after.log`: Post-optimization data
- `performance_comparison.txt`: Detailed analysis
- `performance_comparison.png`: Visual graphs (if gnuplot installed)

## ⚙️ System Optimization

When you run the optimization script, it:
1. Installs latest NVIDIA drivers (545)
2. Sets up optimal SWAP (110GB for LLM)
3. Tunes kernel parameters
4. Configures GPU for maximum performance
5. Optimizes system for LLM workloads

To run optimization:
```bash
sudo nvidia-optimize
```

## ⚠️ Important Notes

- Always backup your system before optimization
- System restart is required after optimization
- SWAP size is set to 110GB (optimized for Llama 3.2 Vision)
- All settings are tuned specifically for RTX 4060

## 🔄 Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and updates.

## 📝 License

Apache 2 License

## 🤝 Contributing

Issues and pull requests are welcome! Check our [CHANGELOG.md](CHANGELOG.md) for recent updates.

## 🧪 Testing

The suite includes comprehensive tests:
- Unit tests for all tools
- Integration tests
- Docker-based test environment

To run tests:
```bash
./run_tests.sh
