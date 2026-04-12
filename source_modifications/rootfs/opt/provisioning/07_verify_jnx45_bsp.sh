#!/bin/bash
# 07_verify_jnx45_bsp.sh (Runs inside Chroot)

set -e

echo "========================================"
echo "--> Auditing JNX45 BSP Internal Alignment"
echo "========================================"

# 1. Define target hardware identifiers
JNX_DTB="tegra234-p3767-0004-jnx45.dtb"
EXTLINUX_CONF="/boot/extlinux/extlinux.conf"

# 2. Verify DTB Existence
# If script 02 and 04 worked, this file MUST be in /boot
echo "[CHECK] Verifying Auvidea DTB presence in /boot..."
if [ -f "/boot/$JNX_DTB" ]; then
    echo "PASS: Found $JNX_DTB"
else
    echo "FAIL: $JNX_DTB is missing from /boot! Hardware will not initialize correctly."
    exit 1
fi

# 3. Verify Extlinux Configuration
# Double-check the path injected by script 04
echo "[CHECK] Verifying extlinux.conf FDT pointer..."
if grep -q "FDT /boot/$JNX_DTB" "$EXTLINUX_CONF"; then
    echo "PASS: extlinux.conf points to $JNX_DTB"
else
    echo "FAIL: extlinux.conf is NOT configured for JNX45. Falling back to generic boot."
    exit 1
fi

# 4. Aerospace Hardening: UART & MCU Permissions
# Since Stalbridge tools will likely need to talk to the MCU over UART
# without requiring sudo every time, we set up group permissions here.
echo "[CONFIG] Setting dialout permissions for MCU and LTE UARTs..."
# Ensure the dialout group exists (standard in Ubuntu/L4T)
# This allows the user/services to access /dev/ttyTCU0 (Console/MCU) and /dev/ttyTHS*
# Note: In chroot, we are just verifying the 'dialout' group is ready.
if getent group dialout > /dev/null; then
    echo "PASS: 'dialout' group identified for hardware access."
else
    echo "WARN: 'dialout' group missing. Creating..."
    groupadd -r dialout
fi

# 5. Kernel Check
echo "[INFO] Internal Kernel Version: $(uname -r 2>/dev/null || echo 'Chroot-Standard')"
echo "[INFO] BSP check complete for JNX45 / Orin Nano 8GB."

echo "========================================"