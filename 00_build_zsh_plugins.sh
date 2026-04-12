#!/bin/bash

set -e 

# Ensure the target directory structure exists
mkdir -p "source_modifications/roofs/usr/share/zsh-plugins"

# Clone the repositories
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "source_modifications/rootfs/usr/share/zsh-plugins/zsh-autosuggestions"

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "source_modifications/rootfs/usr/share/zsh-plugins/zsh-syntax-highlighting"

git clone https://github.com/marlonrichert/zsh-autocomplete \
    "source_modifications/rootfs/usr/share/zsh-plugins/zsh-autocomplete"

echo "Installed zsh plugins."