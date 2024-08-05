#!/bin/bash

if [[ "$(grep "/${USER}:" /etc/passwd | awk -F '/' '{print $NF}')" != "zsh" ]]; then
    echo -e "\033[0;32m[SHELL]\033[0m changing shell to zsh..."
    chsh -s "$(which "zsh")"
else
    echo -e "\033[0;33m[SKIP]\033[0m zsh is already set as shell..."
fi

clear
