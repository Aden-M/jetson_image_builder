#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Capture the current working directory (assumed to be the workspace root)
WORKSPACE_ROOT="$(pwd)"

# FIX: Default to the extracted Jetson rootfs, or accept a passed argument
ROOTFS_DIR="${1:-${WORKSPACE_ROOT}/Linux_for_Tegra/rootfs}"

# Resolve to a strict absolute path to guarantee mount/chroot compatibility
ROOTFS_DIR="$(realpath "$ROOTFS_DIR")"

echo "Preparing chroot environment in: $ROOTFS_DIR"

# 1. Ensure QEMU emulator is present in the target filesystem
sudo cp /usr/bin/qemu-aarch64-static "$ROOTFS_DIR/usr/bin/"

# 2. Mount sequence 
echo "Mounting host directories..."
sudo mount --bind /dev "$ROOTFS_DIR/dev"
sudo mount --bind /dev/pts "$ROOTFS_DIR/dev/pts"
sudo mount --bind /sys "$ROOTFS_DIR/sys"
sudo mount --bind /proc "$ROOTFS_DIR/proc"
sudo mount --bind /etc/resolv.conf "$ROOTFS_DIR/etc/resolv.conf"

echo "Executing provisioning payload inside chroot..."

# 3. Enter the environment and run the master installer
sudo chroot "$ROOTFS_DIR" /bin/bash -c "/opt/provisioning/00_install_all.sh"

# --- Control returns here after the chroot payload finishes ---

# 4. Unmount sequence
echo "Cleaning up mounts..."
sudo umount "$ROOTFS_DIR/etc/resolv.conf"
sudo umount "$ROOTFS_DIR/proc"
sudo umount "$ROOTFS_DIR/sys"
sudo umount "$ROOTFS_DIR/dev/pts"
sudo umount "$ROOTFS_DIR/dev"

echo "Chroot environment successfully unmounted."