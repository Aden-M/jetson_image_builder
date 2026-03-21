#!/bin/bash
# 02_setup_keys.sh (Chroot)

set -e

TARGET_USER="jetson"
TARGET_HOME="/home/${TARGET_USER}"
STAGED_KEYS="/opt/provisioning/keys"

echo "Configuring SSH keys for user: ${TARGET_USER}..."

mkdir -p "${TARGET_HOME}/.ssh"

if [ -d "$STAGED_KEYS" ] && [ "$(ls -A $STAGED_KEYS)" ]; then
    cp -a ${STAGED_KEYS}/* "${TARGET_HOME}/.ssh/"
    
    chmod 700 "${TARGET_HOME}/.ssh"
    find "${TARGET_HOME}/.ssh" -type f -exec chmod 600 {} \;
    find "${TARGET_HOME}/.ssh" -type f -name "*.pub" -exec chmod 644 {} \;
    
    if [ -f "${TARGET_HOME}/.ssh/authorized_keys" ]; then
        chmod 644 "${TARGET_HOME}/.ssh/authorized_keys"
    fi

    # Ensure the user owns the folder, looking up their UID dynamically
    chown -R ${TARGET_USER}:${TARGET_USER} "${TARGET_HOME}/.ssh"
    
    echo "SSH keys installed and secured."
else
    echo "No keys found in staging area. Skipping."
fi