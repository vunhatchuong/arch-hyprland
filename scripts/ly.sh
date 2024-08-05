#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/header.sh"

printf "${INFO} Installing Ly........\n"
_installWithYay "ly"
[ $? -ne 0 ] && {
    echo -e "${ERROR} Ly installation failed"
    exit 1
}

# Check if other login managers installed and disabling its service before enabling Ly
for login_manager in lightdm gdm lxdm lxdm-gtk3 sddm; do
    if pacman -Qs "$login_manager" >/dev/null; then
        echo "${INFO} Disabling $login_manager..."
        sudo systemctl disable "$login_manager.service"
    fi
done

printf " Activating Ly service........\n"
sudo systemctl enable ly.service

if grep -qi "EndeavourOS" /etc/os-release; then
    echo "${INFO} EndeavourOS detected, removing GRUB theme"
    sudo cp /etc/default/grub /etc/default/grub.bak
    sudo sed -i 's|.*GRUB_BACKGROUND=.*|#GRUB_BACKGROUND=|' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

clear
