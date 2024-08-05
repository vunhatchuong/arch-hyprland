#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/header.sh"

printf "${INFO} Downloading Dotter dotfile manager....\n"
_installWithYay "dotter-rs-bin"
[ $? -ne 0 ] && {
    echo -e "\e[1A\e[K${ERROR} - Dotter installation failed"
    exit 1
}

printf "${INFO} Cloning dotfiles repository...\n"
if git clone https://github.com/vunhatchuong/.dotfiles.git "$HOME/.dotfiles"; then
    cp -r "$HOME/Arch-Hyprland/assets/local.toml" "$HOME/.dotfiles/.dotter/"
    cd "$HOME/.dotfiles"
    dotter
    echo -e "${OK} Dotfiles processed successfully."
else
    echo -e "${ERROR} Failed to clone the Dotfiles."
    exit 1
fi

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --keep

clear
