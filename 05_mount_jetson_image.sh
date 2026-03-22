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

echo "Preparing chroot environment in: $ROOTFS_DIR"
echo "Target Architecture (SOC): $JETSON_SOC"

# 1. Define the foolproof cleanup function
cleanup() {
    echo "Unmounting chroot directories..."
    sudo umount "$ROOTFS_DIR/etc/resolv.conf" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/proc" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/sys" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/dev/pts" 2>/dev/null || true
    sudo umount "$ROOTFS_DIR/dev" 2>/dev/null || true
    echo "Cleanup finished."
}

# 2. TRAP: Bind the cleanup function to EXIT only
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

echo "Executing provisioning payload inside chroot..."

# 5. Pre-chroot Configuration Injections
sudo chmod +x "$ROOTFS_DIR/opt/provisioning/00_install_all.sh"

# Resolve the APT <SOC> placeholder dynamically
sudo sed -i "s/<SOC>/${JETSON_SOC}/g" "$ROOTFS_DIR/etc/apt/sources.list.d/nvidia-l4t-apt-source.list"

# 6. Enter the environment and run the master installer
sudo chroot "$ROOTFS_DIR" /bin/bash -c "/opt/provisioning/00_install_all.sh"

# --- Control returns here, and the trap automatically handles unmounting ---