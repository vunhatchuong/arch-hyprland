colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$RESET"
}

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
    local prompt="$1"
    local response_var="$2"

    # Check if a preset value exists and is valid
    if [[ -n "${!response_var}" ]]; then
        echo "$(colorize_prompt "$CAT" "$prompt (Preset): ${!response_var}")"
        if [[ "${!response_var}" = [Yy] ]]; then
            return 0
        else
            return 1
        fi
    else
        printf -v "$response_var" ""
    fi

    while true; do
        read -p "$(colorize_prompt "$CAT" "$prompt (y/n): ")" choice
        case "$choice" in
        [Yy]*)
            eval "$response_var='Y'"
            return 0
            ;;
        [Nn]*)
            eval "$response_var='N'"
            return 1
            ;;
        *) echo "Please answer with y or n." ;;
        esac
    done
}

execute_script() {
    local script="$1"
    local script_path="$SCRIPT_DIR/$script"

    if [ -f "$script_path" ]; then
        env USE_PRESET=$use_preset "$script_path"
    else
        echo "$(colorize_prompt "$ERROR" "Script '$script' not found in '$script_directory'.")"
    fi
}
