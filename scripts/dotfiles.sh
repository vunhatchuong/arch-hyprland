#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/color.sh"
source "${scrDir}/library/dialog.sh"

printf "${INFO} Downloading Dotter dotfile manager....\n"
_installWithYay "dotter-rs-bin"
[ $? -ne 0 ] && {
    echo -e "\e[1A\e[K${ERROR} - Dotter installation failed"
    exit 1
}

printf "${INFO} Cloning dotfiles repository...\n"
if git clone https://github.com/vunhatchuong/.dotfiles.git "$HOME/.dotfiles"; then
    cp -r "$HOME/arch-hyprland/assets/dotfiles-local.toml" "$HOME/.dotfiles/.dotter/local.toml"
    cd "$HOME/.dotfiles"
    dotter
    echo -e "${OK} Dotfiles processed successfully."
else
    echo -e "${ERROR} Failed to clone the Dotfiles."
    exit 1
fi

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --keep

echo
ask_yes_no "-Do you want to download Wallpapers?" wallpapers
if [ "$wallpapers" == "Y" ]; then
    if git clone https://github.com/vunhatchuong/picture-collection.git "$HOME/picture-collection"; then
        echo "${INFO} Wallpapers downloaded successfully."
        cp -r "$HOME/arch-hyprland/assets/wallpapers-local.toml" "$HOME/picture-collection/.dotter/local.toml"
        cd "$HOME/picture-collection"
        dotter
        echo -e "${OK} Wallpapers install successfully."
    else
        echo "${ERROR} Download failed for Icons.."
    fi
fi

clear
