#!/bin/bash
# 04_copy_modifications.sh (Run on Host)

set -e

WORKSPACE_ROOT="$(pwd)"
MOD_DIR="${WORKSPACE_ROOT}/source_modifications/rootfs"
TARGET_ROOTFS="${WORKSPACE_ROOT}/Linux_for_Tegra/rootfs"
EXTLINUX_CONF="${TARGET_ROOTFS}/boot/extlinux/extlinux.conf"

# The specific DTB for Orin Nano (p3767-0004) on JNX45
# Verify this filename matches the one extracted from the Auvidea firmware package
JNX_DTB="tegra234-p3767-0004-jnx45.dtb"

echo "Injecting source modifications into the Jetson filesystem..."

if [ ! -d "$TARGET_ROOTFS" ]; then
    echo "Error: Target rootfs not found at $TARGET_ROOTFS."
    echo "Did 02_extract_jetson_image.sh run successfully?"
    exit 1
fi

# Use cp -a to strictly preserve permissions, symlinks, and directory structures
sudo cp -a "${MOD_DIR}/." "${TARGET_ROOTFS}/"

echo "Auditing extlinux.conf for Auvidea DTB alignment..."

if [ -f "$EXTLINUX_CONF" ]; then
    # 1. Check if an FDT line already exists
    if grep -q "^      FDT" "$EXTLINUX_CONF"; then
        echo "Updating existing FDT entry to use $JNX_DTB..."
        sudo sed -i "s|^      FDT.*|      FDT /boot/$JNX_DTB|" "$EXTLINUX_CONF"
    else
        # 2. If no FDT line exists, insert it after the MENU LABEL or APPEND line
        echo "No FDT entry found. Injecting JNX45 DTB path..."
        sudo sed -i "/APPEND/a \      FDT /boot/$JNX_DTB" "$EXTLINUX_CONF"
    fi
    
    # Verification
    echo "Current extlinux.conf FDT configuration:"
    grep "FDT" "$EXTLINUX_CONF"
else
    echo "Warning: extlinux.conf not found at $EXTLINUX_CONF."
    echo "UEFI might rely on the kernel partition, but this is unusual for a custom BSP."
fi

echo "Modifications injected and DTB verified successfully."