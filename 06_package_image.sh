#!/bin/bash
# 06_package_image.sh (Run on Host)

# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
WORKSPACE_ROOT="$(pwd)"
L4T_DIR="${WORKSPACE_ROOT}/Linux_for_Tegra"
OUTPUT_IMAGE="${WORKSPACE_ROOT}/lunabotics_headless_orin_nano.img"

# Board definition (matches your history)
BOARD="jetson-orin-nano-devkit"
# Target storage medium (SD, NVME, or USB)
STORAGE_DEV="SD"
# ---------------------

echo "Starting Jetson image packaging..."

# 1. Dependency Check
if ! command -v xmlstarlet &> /dev/null; then
    echo "Dependency 'xmlstarlet' not found. Installing..."
    sudo apt-get update && sudo apt-get install -y xmlstarlet
fi

# 2. Directory Check
if [ ! -d "$L4T_DIR" ]; then
    echo "Error: Target directory $L4T_DIR does not exist."
    echo "Are you running this from the workspace root?"
    exit 1
fi

echo "Changing directory to $L4T_DIR..."
cd "$L4T_DIR"

# 3. Build the Image
echo "========================================"
echo "Building flashable disk image..."
echo "Output: $OUTPUT_IMAGE"
echo "Board:  $BOARD"
echo "Device: $STORAGE_DEV"
echo "========================================"

# Execute the official NVIDIA tool
sudo ./tools/jetson-disk-image-creator.sh -o "$OUTPUT_IMAGE" -b "$BOARD" -d "$STORAGE_DEV"

echo ""
echo "========================================"
echo "Success! Image packaging complete."
echo "Your flashable image is located at: $OUTPUT_IMAGE"
echo "You can now flash this to your $STORAGE_DEV using BalenaEtcher or Rufus."