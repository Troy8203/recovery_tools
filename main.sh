#!/bin/bash

current_version="0.0.1"

#Import utils
source "$(dirname "$0")/./lib/utils.sh"
source "$(dirname "$0")/./lib/restore.sh"

check_status() {
    check_ohmyzsh
    check_nerdfonts
    check_starship
    check_rxfetch
    check_colorls
    check_bat
}

check_status

retore_ohmyzsh