#!/bin/bash
# prepare_payload.sh (Run on Host)

set -e

WORKSPACE_ROOT="$(pwd)"
KEYS_DIR="${WORKSPACE_ROOT}/keys"
PROVISIONING_DIR="${WORKSPACE_ROOT}/source_modifications/rootfs/opt/provisioning"

# Ensure the provisioning and key staging directories exist
mkdir -p "${PROVISIONING_DIR}/keys"

# Check if the user has added keys
if [ -z "$(ls -A "${KEYS_DIR}" 2>/dev/null)" ]; then
    echo "Warning: ${KEYS_DIR} is empty or does not exist."
    echo "Please place your SSH keys in ${KEYS_DIR} before building."
    exit 1
fi

# Stage the keys into the provisioning payload
echo "Staging SSH keys for image injection..."
cp -a "${KEYS_DIR}/." "${PROVISIONING_DIR}/keys/"

echo "Payload staged successfully at ${PROVISIONING_DIR}"