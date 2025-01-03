colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
    if [[ ! -z "${!2}" ]]; then
        echo "$(colorize_prompt "$CAT" "$1 (Preset): ${!2}")"
        if [[ "${!2}" = [Yy] ]]; then
            return 0
        else
            return 1
        fi
    else
        eval "$2=''"
    fi
    while true; do
        read -p "$(colorize_prompt "$CAT" "$1 (y/n): ")" choice
        case "$choice" in
        [Yy]*)
            eval "$2='Y'"
            return 0
            ;;
        [Nn]*)
            eval "$2='N'"
            return 1
            ;;
        *) echo "Please answer with y or n." ;;
        esac
    done
}

execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        env USE_PRESET=$use_preset "$script_path"
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}
