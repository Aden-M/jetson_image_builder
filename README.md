# Jetson Image Builder
A  basic automation pipeline for headless NVIDIA Jetson Orin Series Deployment.

# Project Purpose:
This set of scripts and files generates a modified NVIDIA Jetson Orin Series boot image. It automates the extraction of the Linux for Tegra (L4T) BSP, injects user configurations, and handles the complexities of QEMU-based chroot provisioning on an x86 host.

# Default Installation Features:
1. **User Account:** Creates user `jetson` with password: `jetson`.
2. **ROS2:** Pre-installed ROS2 Humble (Standard OSRF Base).
3. **Environment:** Zsh as the default shell with `autosuggestions`, `syntax-highlighting`, and `autocomplete`.
4. **SSH Ready:** Automatic injection of keys from the host `/keys` directory to the target `~/.ssh/`.
5. **Headless Optimization:** Removes heavy desktop components and forces the terminal (CLI) on boot.

# Platform Requirement:
- Generic Ubuntu 22.04 Host (x86/64) 
- WSL Recommended
- Minimum 50GB free disk space

# Usage Guide:
1. Insert desired `~/.ssh/` configuration into `/keys` (remove the placeholder files).
2. Run scripts in order (00 through 06).
3. Flash the resulting image file onto a MicroSD card.
4. Modify scripts as needed to add/remove functionality.

| Script | Name | Description |
| :--- | :--- | :--- |
| **00** | `00_build_zsh_plugins.sh` | Fetches Zsh plugins to the host staging area. |
| **01** | `01_clone_jetson_image.sh` | Downloads NVIDIA L4T BSP and Sample RootFS. |
| **02** | `02_extract_jetson_image.sh` | Extracts OS and applies hardware binaries (Sudo required). |
| **03** | `03_inject_keys.sh` | Stages SSH keys for injection into the image. |
| **04** | `04_copy_modifications.sh` | Overlays the `source_modifications` folder onto the RootFS. |
| **05** | `05_mount_jetson_image.sh` | Mounts chroot and executes the internal `00_install_all.sh` hook. |
| **06** | `06_package_image.sh` | Packages the modified RootFS into a flashable `.img` file. |

> Set the **exact platform** (e.g., t234) in `05_mount_jetson_image.sh`

> Set the **device type** (nvme/sd/usb) in `06_package_image.sh`

# Troubleshooting:
- **WSL Terminal Error:** If you see `sudo: unable to allocate pty`, run `wsl --shutdown` in PowerShell to reset the environment and clear stuck mounts.