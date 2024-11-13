#!/bin/bash

# Function: install_nvidia_drivers
## Description: Installs NVIDIA drivers for RTX 4060, CUDA Toolkit, and additional tools.
#              This function performs the following tasks:
#              - Removes old NVIDIA drivers and nouveau
#              - Blacklists nouveau driver
#              - Updates initramfs
#              - Adds GPU PPA repository
#              - Installs latest NVIDIA drivers (version 545)
#              - Installs CUDA Toolkit
#              - Installs additional NVIDIA tools
#              - Verifies the installation
#
## Returns:
#   0 - If the installation is successful
#   1 - If the installation fails
#
## Usage: install_nvidia_drivers

install_nvidia_drivers() {
    echo "Rozpoczynam instalację sterowników NVIDIA dla RTX 4060..."

    # Usunięcie starych sterowników i nouveau
    echo "Usuwanie starych sterowników..."
    apt purge -y nvidia* libnvidia*

    # Dodanie do blacklisty nouveau
    echo "Wyłączanie sterownika nouveau..."
    cat > /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
options nouveau modeset=0
EOF

    # Aktualizacja initramfs
    update-initramfs -u

    # Dodanie repozytorium GPU PPA
    add-apt-repository -y ppa:graphics-drivers/ppa
    apt update

    # Instalacja najnowszych sterowników NVIDIA
    echo "Instalacja sterowników NVIDIA..."
    apt install -y nvidia-driver-545 nvidia-dkms-545

    # Instalacja CUDA Toolkit
    echo "Instalacja CUDA Toolkit..."
    apt install -y nvidia-cuda-toolkit

    # Instalacja narzędzi dodatkowych
    apt install -y nvidia-settings nvidia-prime

    # Weryfikacja instalacji
    echo "Weryfikacja instalacji sterowników..."
    if nvidia-smi &>/dev/null; then
        echo "Sterowniki NVIDIA zainstalowane pomyślnie!"
        nvidia-smi
        return 0
    else
        echo "BŁĄD: Instalacja sterowników nie powiodła się!"
        return 1
    fi
}

echo "Rozpoczynam optymalizację systemu Ubuntu 24.10 pod LLM..."

# Instalacja sterowników NVIDIA
install_nvidia_drivers

# Aktualizacja systemu
echo "Aktualizacja systemu..."
apt update && apt upgrade -y

# Instalacja niezbędnych narzędzi
echo "Instalacja narzędzi..."
apt install -y htop nvtop cmake build-essential python3-dev cpupower-gui

# Konfiguracja SWAP
echo "Konfiguracja SWAP..."
SWAP_SIZE="110G"  # Dla Llama 3.2 Vision
swapoff -a
# Utworzenie pliku SWAP
dd if=/dev/zero of=/swapfile bs=1G count=110
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
# Dodanie do /etc/fstab jeśli nie istnieje
if ! grep -q "/swapfile" /etc/fstab; then
    echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi

# Optymalizacja parametrów kernela
echo "Konfiguracja parametrów systemowych..."
cat > /etc/sysctl.d/99-llm-optimization.conf << EOF
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=60
vm.dirty_background_ratio=30
net.core.rmem_max=26214400
net.core.wmem_max=26214400
net.ipv4.tcp_rmem=4096 87380 26214400
net.ipv4.tcp_wmem=4096 87380 26214400
EOF

sysctl -p /etc/sysctl.d/99-llm-optimization.conf

# Optymalizacja NVIDIA
echo "Konfiguracja NVIDIA..."
# Włączenie trybu persistenced
nvidia-smi -pm 1
# Wyłączenie auto-boost
nvidia-smi --auto-boost-default=0
# Maksymalne takty dla RTX 4060
nvidia-smi -ac 3615,1530

# Optymalizacja zasilania NVIDIA
nvidia-smi --power-limit=115  # Limit mocy dla RTX 4060
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"  # Tryb maksymalnej wydajności

# Konfiguracja CPU
echo "Konfiguracja CPU..."
# Ustawienie governor na performance
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" > $governor
done

# Utworzenie skryptu startowego dla Ollama
echo "Tworzenie skryptu startowego dla Ollama..."
cat > /usr/local/bin/run-ollama << EOF
#!/bin/bash
# Ustawienie zmiennych środowiskowych
export CUDA_VISIBLE_DEVICES=0
export OMP_NUM_THREADS=\$(nproc)
# Ustawienie zmiennych CUDA
export CUDA_CACHE_PATH=\$HOME/.cache/cuda
export CUDA_CACHE_MAXSIZE=2147483648
# Optymalizacja pamięci CUDA
export CUDA_FORCE_PTX_JIT=1
export CUDA_AUTO_BOOST=0

# Zwiększenie limitów systemowych
ulimit -n 1048576
ulimit -v unlimited

# Uruchomienie Ollama z odpowiednimi parametrami
exec ollama "\$@"
EOF

chmod +x /usr/local/bin/run-ollama

# Wyłączenie zbędnych usług
echo "Wyłączanie zbędnych usług..."
systemctl disable snapd
systemctl stop snapd
systemctl disable packagekit
systemctl stop packagekit

# Optymalizacja I/O dla dysków
echo "Optymalizacja I/O..."
for disk in $(lsblk -d -o name | grep -v NAME); do
    if [[ $disk == nvme* ]]; then
        echo "deadline" > /sys/block/$disk/queue/scheduler
    fi
done

echo "Optymalizacja i instalacja sterowników zakończona. Proszę zrestartować system."
echo "Po restarcie możesz:"
echo "1. Sprawdzić status sterowników NVIDIA: nvidia-smi"
echo "2. Używać 'run-ollama' do uruchamiania Ollama z optymalnymi ustawieniami"
echo "3. Użyć 'monitor-llm' do monitorowania zasobów"
echo "4. Użyć 'reset-nvidia' do przywrócenia optymalnych ustawień karty"
echo "5. Sprawdzić logi systemowe w przypadku problemów: journalctl -xe"