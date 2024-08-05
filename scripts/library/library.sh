# 0 is True, 1 is False

_isInstalled() {
    local package="$1"
    if pacman -Qi "${package}" &>/dev/null; then
        return 0
    fi
    return 1
}

_isAvailable() {
    local PkgIn=$1

    if pacman -Si "${PkgIn}" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

_isAvailableYay() {
    local package="$1"
    if yay -Si "${package}" &>/dev/null; then
        return 0
    fi
    return 1
}

_installWithPacman() {
    if [[ $(_isInstalled "$1") == 0 ]]; then
        echo "${OK} $1 is already installed."
    else
        sudo pacman -S --noconfirm "$1"
    fi
}

_installWithYay() {
    if [[ $(_isInstalled "$1") == 0 ]]; then
        echo "${OK} $1 is already installed."
    else
        yay -S --noconfirm "$1"
    fi
}

_uninstall_package() {
    toUninstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") != 0 ]]; then
            continue
        fi
        toUninstall+=("${pkg}")
    done
    if [[ "${toUninstall[@]}" == "" ]]; then
        return
    fi
    printf "${NOTE} Uninstalling:\n%s\n" "${toUninstall[@]}"
    sudo pacman -Rns --noconfirm "${toUninstall[@]}"
}
