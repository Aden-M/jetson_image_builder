#!/bin/bash
# 01_create_user.sh (Chroot)

set -e

TARGET_USER="jetson"

echo "Ensuring user '${TARGET_USER}' exists..."

# Check if user exists, create if they do not
if ! id "$TARGET_USER" &>/dev/null; then
    echo "Creating user ${TARGET_USER}..."
    useradd -m -s /bin/bash "$TARGET_USER"
    
    # Set default password to 'jetson' (can be forced to change on first boot later)
    echo "${TARGET_USER}:jetson" | chpasswd
    
    # Add to standard Jetson/Ubuntu groups
    usermod -aG sudo,adm,dialout,cdrom,floppy,audio,dip,video,plugdev "$TARGET_USER"
    echo "User created successfully."
else
    echo "User ${TARGET_USER} already exists. Skipping creation."
fi