#!/bin/bash
# 05_make_headless.sh (Runs inside Chroot)

set -e

echo "Converting image to headless (CLI only)..."

# 1. Change the default systemd boot target to CLI
# This prevents the system from attempting to launch a display manager on boot.
echo "Setting default boot target to multi-user.target..."
systemctl set-default multi-user.target

# 2. Purge the heavy desktop environment packages
# Removing ubuntu-desktop and gdm3 clears out GNOME and the login screen.
echo "Purging desktop environment packages to save space..."
export DEBIAN_FRONTEND=noninteractive
apt-get remove --purge -y \
    ubuntu-desktop \
    gdm3 \
    gnome-shell \

# 3. Clean up orphaned dependencies left behind by the desktop environment
echo "Autoremoving orphaned GUI dependencies..."
apt-get autoremove -y
apt-get clean

echo "Headless configuration complete."