#!/bin/bash
# 02_extract_jetson_image.sh

set -e

L4T_RELEASE="36.5.0"
BSP_PKG="jetson_linux_r${L4T_RELEASE}_aarch64.tbz2"
ROOTFS_PKG="tegra_linux_sample-root-filesystem_r${L4T_RELEASE}_aarch64.tbz2"

echo "Extracting Jetson Linux BSP..."
if [ -f "$BSP_PKG" ]; then
    tar -xjf "$BSP_PKG"
else
    echo "Error: $BSP_PKG not found."
    exit 1
fi

echo "Extracting Sample Root Filesystem (requires sudo)..."
if [ -f "$ROOTFS_PKG" ]; then
    cd Linux_for_Tegra/rootfs/
    # sudo is MANDATORY here to preserve exact ownership and permissions of the base OS
    sudo tar -xpf ../../"$ROOTFS_PKG"
    cd ../../
else
    echo "Error: $ROOTFS_PKG not found."
    exit 1
fi

echo "Applying NVIDIA hardware binaries to the rootfs..."
cd Linux_for_Tegra/
sudo ./apply_binaries.sh
cd ..

echo "Extraction and base initialization complete."