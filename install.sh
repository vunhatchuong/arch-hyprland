#!/bin/bash

source scripts/library/header.sh
source scripts/library/library.sh
source scripts/library/dialog.sh
script_directory=scripts

read -p "${CAT} Would you like to Use Preset Settings? (y/n): " use_preset

if [[ $use_preset = [Yy] ]]; then
    source ./preset.sh
fi

echo "${INFO} Updating Pacman...."
sudo pacman -Sy

execute_script "installer.sh"

echo
ask_yes_no "-Do you have any nvidia gpu in your system?" nvidia
echo
ask_yes_no "-Install Snapper?" snapper
echo
ask_yes_no "-Download pre-configured Hyprland dotfiles?" dots
echo
ask_yes_no "-Install developers tools?" developer
echo

if [ "$ui" == "Y" ]; then
    execute_script "ui.sh"
fi

if [ "$nvidia" == "Y" ] && [ "$ui" == "Y" ]; then
    execute_script "nvidia.sh"
fi

if [ "$ui" == "Y" ]; then
    execute_script "ly.sh"
fi

if [ "$ui" == "Y" ]; then
    execute_script "gtk.sh"
fi

execute_script "zsh.sh"

if [ "$snapper" == "Y" ] && [ "$ui" == "Y" ]; then
    execute_script "snapper.sh"
fi

if [ "$ui" == "Y" ]; then
    execute_script "system_enable.sh"
fi

if [ "$dots" == "Y" ]; then
    execute_script "dotfiles.sh"
fi

if [ "$developer" == "Y" ]; then
    execute_script "developer.sh"
fi

printf "\n${OK} Installation Completed.\n"
printf "\n"
sleep 2

if [ "$snapper" == "Y" ]; then
    read -p "${NOTE} Reminder: Run btrfs-assistant to configure snapper"
fi

if [ "$developer" == "Y" ]; then
    read -p "${NOTE} Reminder: Run 'vfox use -g' after reboot"
fi

# Remove EndeavourOS ugly Grub theme
if grep -qi "EndeavourOS" /etc/os-release; then
    echo "${INFO} EndeavourOS detected, removing GRUB theme"
    sudo cp /etc/default/grub /etc/default/grub.bak
    sudo sed -i 's|.*GRUB_BACKGROUND=.*|#GRUB_BACKGROUND=|' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
    systemctl reboot
fi
