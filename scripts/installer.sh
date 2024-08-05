#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/library/library.sh"
source "${scrDir}/library/header.sh"

listPkg="${scrDir}/pkg.lst"
archPkg=()
aurhPkg=()
ofs=$IFS
IFS='|'

while read -r pkg deps; do
    pkg="${pkg// /}"
    if [ -z "${pkg}" ]; then
        continue
    fi

    if [ ! -z "${deps}" ]; then
        deps="${deps%"${deps##*[![:space:]]}"}"
        while read -r cdep; do
            pass=$(cut -d '#' -f 1 "${listPkg}" | awk -F '|' -v chk="${cdep}" '{if($1 == chk) {print 1;exit}}')
            if [ -z "${pass}" ]; then
                if _isInstalled "${cdep}"; then
                    pass=1
                else
                    break
                fi
            fi
        done < <(echo "${deps}" | xargs -n1)

        if [[ ${pass} -ne 1 ]]; then
            echo -e "\033[0;33m[skip]\033[0m ${pkg} is missing (${deps}) dependency..."
            continue
        fi
    fi

    if _isInstalled "${pkg}"; then
        echo -e "${OK} ${pkg} is already installed..."
    elif _isInstalled "${pkg}"; then
        repo=$(pacman -Si "${pkg}" | awk -F ': ' '/Repository / {print $2}')
        echo -e "${PACMAN} ${pkg} will install from official arch repo..."
        archPkg+=("${pkg}")
    elif _isInstalledYay "${pkg}"; then
        echo -e "${YAY} ${pkg} will install from arch user repo..."
        aurhPkg+=("${pkg}")
    else
        echo "${ERROR}Error: unknown package ${pkg}..."
    fi
done < <(cut -d '#' -f 1 "${listPkg}")

IFS=${ofs}

if [[ ${#archPkg[@]} -gt 0 ]]; then
    sudo pacman -S --noconfirm "${archPkg[@]}"
fi

if [[ ${#aurhPkg[@]} -gt 0 ]]; then
    yay -S --noconfirm "${aurhPkg[@]}"
fi
