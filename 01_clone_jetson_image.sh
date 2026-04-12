#!/bin/bash

# Define L4T Release version
export L4T_RELEASE="36.5.0"

# Define Base URL for NVIDIA downloads
export L4T_URL_BASE="https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/release"

# Define Auvidea Firmware URL (Update with exact link for your JetPack version)
export AUVIDEA_FW_URL="https://auvidea.eu/download/firmware/JNXxx/JNXxx_v2.2_for_JP6.x.tar.gz"
export AUVIDEA_FW_ARCHIVE=$(basename "$AUVIDEA_FW_URL")

# Download Jetson Linux BSP
echo "Downloading Jetson Linux BSP..."
wget -c "${L4T_URL_BASE}/jetson_linux_r${L4T_RELEASE}_aarch64.tbz2"

# Download Sample Root Filesystem
echo "Downloading Sample Root Filesystem..."
wget -c "${L4T_URL_BASE}/tegra_linux_sample-root-filesystem_r${L4T_RELEASE}_aarch64.tbz2"

# Download Auvidea Firmware Overlay
echo "Downloading Auvidea JNX45 Firmware..."
wget -c "$AUVIDEA_FW_URL"

echo "Downloads complete."