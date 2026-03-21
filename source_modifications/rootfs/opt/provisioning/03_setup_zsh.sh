#!/bin/bash
# 03_setup_zsh.sh (Chroot)

set -e

TARGET_USER="jetson"

echo "Installing Zsh base package..."
apt-get update && apt-get install -y zsh

# The plugins are already in /usr/share/zsh-plugins thanks to host script 00 and 04.
# The .zshrc is already in ~ thanks to /etc/skel and payload 01.

# Set Zsh as the default shell for the target user
echo "Changing default shell for ${TARGET_USER} to Zsh..."
chsh -s $(which zsh) "${TARGET_USER}"

echo "Zsh configured."