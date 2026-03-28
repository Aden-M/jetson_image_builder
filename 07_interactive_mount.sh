#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
# t234 = Orin, t194 = Xavier, t186 = TX2, t210 = Nano/TX1
JETSON_SOC="t234" 
WORKSPACE_ROOT="$(pwd)"
ROOTFS_DIR="${1:-${WORKSPACE_ROOT}/Linux_for_Tegra/rootfs}"
ROOTFS_DIR="$(realpath "$ROOTFS_DIR")"
# ---------------------

echo "Preparing INTERACTIVE chroot environment in: $ROOTFS_DIR"
echo "Target Architecture (SOC): $JETSON_SOC"

# 1. Define the foolproof cleanup function
cleanup() {
    echo -e "\nExiting interactive session. Unmounting chroot directories..."
    sudo umount "$ROOTFS_DIR/etc/resolv.conf" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/proc" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/sys" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/dev/pts" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/dev" 2>/dev/null || true
    echo "Cleanup finished."
}

# 2. TRAP: Bind the cleanup function to EXIT
# This guarantees execution on normal exit, Ctrl+C (via bash exit), or a crash due to 'set -e'
trap cleanup EXIT

# 3. Ensure QEMU emulator is present
sudo cp /usr/bin/qemu-aarch64-static "$ROOTFS_DIR/usr/bin/qemu-aarch64-static"

# 4. Mount sequence
echo "Mounting host directories..."
sudo mount --bind /dev "$ROOTFS_DIR/dev"
sudo mount -t devpts devpts "$ROOTFS_DIR/dev/pts"
sudo mount --bind /sys "$ROOTFS_DIR/sys"
sudo mount --bind /proc "$ROOTFS_DIR/proc"
sudo mount --bind /etc/resolv.conf "$ROOTFS_DIR/etc/resolv.conf"

echo "--------------------------------------------------------"
echo " Entering interactive chroot shell."
echo " Type 'exit' or press Ctrl+D to leave and trigger cleanup."
echo "--------------------------------------------------------"

# 5. Enter the environment with an interactive bash shell
sudo chroot "$ROOTFS_DIR" /bin/bash

# --- Control returns here upon exit, and the trap automatically handles unmounting ---