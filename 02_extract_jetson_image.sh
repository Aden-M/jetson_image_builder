#!/bin/bash
# 02_extract_jetson_image.sh

set -e

L4T_RELEASE="36.5.0"
BSP_PKG="jetson_linux_r${L4T_RELEASE}_aarch64.tbz2"
ROOTFS_PKG="tegra_linux_sample-root-filesystem_r${L4T_RELEASE}_aarch64.tbz2"
AUVIDEA_FW_ARCHIVE="JNXxx_v2.2_for_JP6.x.tar.gz" # Match the archive from script 01

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

echo "Applying Auvidea JNX45 Firmware Overlay..."
if [ -f "$AUVIDEA_FW_ARCHIVE" ]; then
    # Extract Auvidea overlay directly into the Linux_for_Tegra directory.
    # This overwrites NVIDIA's default kernel/DTBs and adds the custom flash script.
    # Adjust tar flags (-xzf for gzip, -xjf for bzip2) based on the actual Auvidea download format.
    tar -xzf "$AUVIDEA_FW_ARCHIVE" -C Linux_for_Tegra/
else
    echo "Error: $AUVIDEA_FW_ARCHIVE not found."
    exit 1
fi

echo "Applying NVIDIA hardware binaries and Auvidea modifications to the rootfs..."
cd Linux_for_Tegra/
sudo ./apply_binaries.sh
cd ..

echo "Extraction, overlay integration, and base initialization complete."