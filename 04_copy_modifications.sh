#!/bin/bash
# 04_copy_modifications.sh (Run on Host)

set -e

WORKSPACE_ROOT="$(pwd)"
MOD_DIR="${WORKSPACE_ROOT}/source_modifications/rootfs"
TARGET_ROOTFS="${WORKSPACE_ROOT}/Linux_for_Tegra/rootfs"

echo "Injecting source modifications into the Jetson filesystem..."

if [ ! -d "$TARGET_ROOTFS" ]; then
    echo "Error: Target rootfs not found at $TARGET_ROOTFS."
    echo "Did 02_extract_jetson_image.sh run successfully?"
    exit 1
fi

# Use cp -a to strictly preserve permissions, symlinks, and directory structures
sudo cp -a "${MOD_DIR}/." "${TARGET_ROOTFS}/"

echo "Modifications injected successfully."