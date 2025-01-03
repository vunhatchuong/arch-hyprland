#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/color.sh"

echo "${INFO} Cloning GTK themes and Icons repository..."
if git clone --depth 1 https://github.com/pwyde/monochrome-kde.git; then
    mkdir -p ~/.icons
    mkdir -p ~/.themes
    cd monochrome-kde
    echo "${INFO} Copy GTK Theme to ~/.themes folder"
    cp -r gtk/Monochrome ~/.themes
    cd ..
else
    echo "${ERROR} Download failed for GTK themes.."
fi

if git clone --depth 1 https://github.com/vinceliuice/Tela-circle-icon-theme.git; then
    cd Tela-circle-icon-theme
    echo "${INFO} Install Tela-circle-icon-theme to ~/.icons folder."
    chmod +x install.sh
    ./install.sh black
    cd ..
else
    echo "${ERROR} Download failed for Icons.."
fi

tar -xf "assets/Bibata-Modern-Ice.tar.xz" -C ~/.icons
echo "${OK} Extracted Bibata-Modern-Ice.tar.xz to ~/.icons folder."

clear
