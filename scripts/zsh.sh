#!/bin/bash

current_shell=$(grep "/${USER}:" /etc/passwd | awk -F '/' '{print $NF}')
zsh_path=$(which zsh)

if [[ "$current_shell" != "zsh" ]]; then
    echo -e "\033[0;32m[SHELL]\033[0m changing shell to zsh..."
    chsh -s "$zsh_path"
else
    echo -e "\033[0;33m[SKIP]\033[0m zsh is already set as shell..."
fi

clear
