clear

RESET="$(tput sgr0)"
BOLD="$(tput bold)"

BLUE="${BOLD}$(tput setaf 4)"
GREEN="${BOLD}$(tput setaf 2)"
RED="${BOLD}$(tput setaf 1)"
YELLOW="${BOLD}$(tput setaf 3)"
ORANGE="${BOLD}$(tput setaf 166)"
CYAN="${BOLD}$(tput setaf 6)"

INFO="${BOLD}${BLUE}[INFO]${RESET}"
OK="${BOLD}${GREEN}[OK]${RESET}"
ERROR="${BOLD}${RED}[ERROR]${RESET}"
WARN="${BOLD}${ORANGE}[WARN]${RESET}"
CAT="${CYAN}[ACTION]${RESET}"

PACMAN="$(tput setaf 6)[PACMAN]${RESET}"
YAY="$(tput setaf 14)[YAY]${RESET}"
