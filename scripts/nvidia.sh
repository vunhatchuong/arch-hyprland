#!/bin/bash

# Run EndeavourOS nvidia installer
nvidia-inst

# Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
    echo "${INFO} Nvidia modules already included in /etc/mkinitcpio.conf"
else
    sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    echo "${INFO} Nvidia modules added in /etc/mkinitcpio.conf"
fi
sudo mkinitcpio -P
printf "\n\n\n"

NVEA="/etc/modprobe.d/nvidia.conf"
if [ -f "$NVEA" ]; then
    printf "${OK} Seems like nvidia-drm modeset=1 is already added in your system..moving on.\n"
    printf "\n"
else
    printf "\n"
    printf "${YELLOW} Adding options to $NVEA..."
    sudo echo -e "options nvidia_drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
    printf "\n"
fi

# Setup GRUB
if [ -f /etc/default/grub ]; then
    # Check if nvidia_drm.modeset=1 is already present
    if ! sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        # Add nvidia_drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
        # Regenerate GRUB configuration
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo "${INFO} nvidia-drm.modeset=1 added to /etc/default/grub"
    else
        echo "${INFO} nvidia-drm.modeset=1 is already present in /etc/default/grub"
    fi
else
    echo "/etc/default/grub does not exist"
fi

clear
