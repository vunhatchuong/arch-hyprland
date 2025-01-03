#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/color.sh"
source "${scrDir}/library/dialog.sh"

_installWithYay "vfox-bin"
[ $? -ne 0 ] && {
    echo -e "\e[1A\e[K${ERROR} - vfox installation failed"
    exit 1
}
echo "${INFO} - Install Version Fox successfully"

echo
ask_yes_no "-Do you want to setup env for Node?" node
if [ "$node" == "Y" ]; then
    vfox install nodejs
fi

echo
ask_yes_no "-Do you want to setup Micromamba?" mmamba
if [ "$mmamba" == "Y" ]; then
    cp assets/.condarc ~/
    echo "${INFO} - installing Micromamba"
    "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
    echo "${INFO} - Create folder manually since the script is bad"
    mkdir ${HOME}/micromamba
fi
