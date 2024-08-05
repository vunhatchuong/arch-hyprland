#!/bin/bash

scrDir=$(dirname "$(realpath "$0")")

while read servChk; do

    if [[ $(systemctl list-units --all -t service --full --no-legend "${servChk}.service" | sed 's/^\s*//g' | cut -f1 -d' ') == "${servChk}.service" ]]; then
        echo -e "\033[0;33m[SKIP]\033[0m ${servChk} service is active..."
    else
        echo -e "\033[0;32m[systemctl]\033[0m starting ${servChk} system service..."
        sudo systemctl enable "${servChk}.service"
        sudo systemctl start "${servChk}.service"
    fi

done <"${scrDir}/system_ctl.lst"
