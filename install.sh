#!/bin/bash

source scripts/library/header.sh

read -p "${CAT} Would you like to Use Preset Settings? (y/n): " use_preset

if [[ $use_preset = [Yy] ]]; then
    source ./preset.sh
fi

source scripts/library/library.sh

script_directory=scripts

echo "${INFO} Updating Pacman...."
sudo pacman -Sy

source scripts/library/dialog.sh

execute_script "installer.sh"

echo
ask_yes_no "-Do you have any nvidia gpu in your system?" nvidia
echo
ask_yes_no "-Install developers tools?" developer
echo
ask_yes_no "-Install Snapper?" snapper
echo
ask_yes_no "-Download pre-configured Hyprland dotfiles?" dots
echo

if [ "$nvidia" == "Y" ]; then
    execute_script "nvidia.sh"
fi

execute_script "ly.sh"

execute_script "gtk.sh"

execute_script "zsh.sh"

if [ "$developer" == "Y" ]; then
    execute_script "developer.sh"
fi

if [ "$snapper" == "Y" ]; then
    execute_script "snapper.sh"
fi

execute_script "system_enable.sh"

if [ "$dots" == "Y" ]; then
    execute_script "dotfiles.sh"

fi

printf "\n${OK} Installation Completed.\n"
printf "\n"
sleep 2

read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
    systemctl reboot
fi
