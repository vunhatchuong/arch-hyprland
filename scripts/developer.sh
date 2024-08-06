#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/header.sh"

echo
ask_yes_no "-Do you want to setup env for Node?" node
if [ "$node" == "Y" ]; then
    _installWithYay "fnm-bin"
    [ $? -ne 0 ] && {
        echo -e "\e[1A\e[K${ERROR} - fnm installation failed"
        exit 1
    }
fi

echo
ask_yes_no "-Do you want to setup env for Python?" python
if [ "$python" == "Y" ]; then
    cp assets/.condarc ~/
    echo "${INFO} - installing Micromamba"
    "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
fi

echo
ask_yes_no "-Do you want to setup env for Golang?" golang
if [ "$golang" == "Y" ]; then
    echo "${INFO} - installing Gobrew version manager"
    curl -sL https://raw.githubusercontent.com/kevincobain2000/gobrew/master/git.io.sh | sh
    gobrew
fi
