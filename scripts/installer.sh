#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/header.sh"

listPkg="${scrDir}/pkg.lst"
archPkg=()
aurhPkg=()

while read -r pkg; do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ]; then
        continue
    fi

    if _isInstalled "${pkg}"; then
        echo -e "${OK} ${pkg} is already installed..."
    elif _isAvailable "${pkg}"; then
        repo=$(pacman -Si "${pkg}" | awk -F ': ' '/Repository / {print $2}')
        echo -e "${PACMAN} ${pkg} will install with Pacman..."
        archPkg+=("${pkg}")
    elif _isAvailableYay "${pkg}"; then
        echo -e "${YAY} ${pkg} will install from AUR..."
        aurhPkg+=("${pkg}")
    else
        echo "${ERROR}Error: unknown package ${pkg}..."
    fi
done < <(cut -d '#' -f 1 "${listPkg}")

if [[ ${#archPkg[@]} -gt 0 ]]; then
    sudo pacman -S --noconfirm "${archPkg[@]}"
fi

if [[ ${#aurhPkg[@]} -gt 0 ]]; then
    yay -S --noconfirm "${aurhPkg[@]}"
fi
