# 0 is True, 1 is False

_isInstalled() {
    local package="$1"
    if pacman -Qi "${package}" &>/dev/null; then
        return 0
    fi
    return 1
}

_isAvailable() {
    local package=$1
    if pacman -Si "${package}" &>/dev/null; then
        return 0
    fi
    return 1
}

_isAvailableYay() {
    local package="$1"
    if yay -Si "${package}" &>/dev/null; then
        return 0
    fi
    return 1
}

_installWithPacman() {
    if _isInstalled "$1"; then
        echo "${OK} $1 is already installed."
    else
        sudo pacman -S --noconfirm "$1"
    fi
}

_installWithYay() {
    if _isInstalled "$1"; then
        echo "${OK} $1 is already installed."
    else
        yay -S --noconfirm "$1"
    fi
}

_uninstall_package() {
    local to_uninstall=()
    for package in "$@"; do
        if _is_installed "${package}"; then
            to_uninstall+=("${package}")
        fi
    done

    for package; do
        if [[ $(_isInstalled "${package}") != 0 ]]; then
            continue
        fi
        toUninstall+=("${package}")
    done

    printf "${NOTE} Uninstalling:\n%s\n" "${toUninstall[@]}"
    sudo pacman -Rns --noconfirm "${toUninstall[@]}"
}
