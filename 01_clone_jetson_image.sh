#!/bin/bash

# Define L4T Release version
export L4T_RELEASE="36.5.0"

# Define Base URL for NVIDIA downloads
export L4T_URL_BASE="https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v5.0/release"

# Download Jetson Linux BSP
echo "Downloading Jetson Linux BSP..."
wget "${L4T_URL_BASE}/jetson_linux_r${L4T_RELEASE}_aarch64.tbz2"

# Download Sample Root Filesystem
echo "Downloading Sample Root Filesystem..."
wget "${L4T_URL_BASE}/tegra_linux_sample-root-filesystem_r${L4T_RELEASE}_aarch64.tbz2"

echo "Downloads complete."