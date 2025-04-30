#!/usr/bin/env bash

#Import utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_PATH=$(pwd)

CURRENT_DATE=$(date +%Y-%m-%d)

#Create backup of shortcuts
create_shortcuts() {
    dconf dump /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ > "$CURRENT_PATH/backup/shortcuts/$CURRENT_DATE.txt"
}

#Restore shortcuts
restore_shortcuts() {
    local last_backup=$(ls "$CURRENT_PATH/backup/shortcuts/" | tail -n 1)
    dconf load /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ < "$CURRENT_PATH/backup/shortcuts/$last_backup.txt"
}