#!/bin/bash

install_packages_from_list() {
    local file_name="$1"
    # Ensure the file has the .lst extension
    [[ "${file_name##*.}" != "lst" ]] && file_name="${file_name}.lst"

    local list_file="${PACKAGES_DIR}/${file_name}"
    if [[ ! -f "$list_file" ]]; then
        echo -e "${ERROR} File not found: $list_file"
        return 1
    fi

    local pacman_packages=()
    local aur_packages=()

    echo -e "${INFO} Installing: $file_name packages."

    while read -r pkg; do
        # Remove whitespace and skip empty lines or comments
        [[ -z "$pkg" || "$pkg" == \#* ]] && continue

        if _isInstalled "$pkg"; then
            echo -e "${OK} ${pkg} is already installed."
        elif _isAvailable "$pkg"; then
            repo=$(pacman -Si "${pkg}" | awk -F ': ' '/Repository / {print $2}')
            echo -e "${PACMAN} ${pkg} will be installed using Pacman."
            pacman_packages+=("$pkg")
        elif _isAvailableYay "$pkg"; then
            echo -e "${YAY} ${pkg} will be installed from AUR."
            aur_packages+=("$pkg")
        else
            echo -e "${ERROR} Unknown package: ${pkg}."
        fi
    done < <(cut -d '#' -f 1 "$list_file")

    if [[ ${#pacman_packages[@]} -gt 0 ]]; then
        sudo pacman -S --noconfirm "${pacman_packages[@]}"
    fi

    if [[ ${#aur_packages[@]} -gt 0 ]]; then
        yay -S --noconfirm "${aur_packages[@]}"
    fi
}
