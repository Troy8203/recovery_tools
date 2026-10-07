#!/bin/bash

current_version="0.2.0"

#Import utils
source "$(dirname "$0")/./lib/utils.sh"
source "$(dirname "$0")/./lib/restore.sh"
source "$(dirname "$0")/./lib/shortcuts.sh"

check_status() {
    local status=0

    check_ohmyzsh || status=1
    check_nerdfonts || status=1
    check_starship || status=1
    check_rxfetch || status=1
    check_colorls || status=1
    check_others || status=1
    check_tmux || status=1
    check_ghostty || status=1
    check_codium || status=1
    check_btop || status=1
    return "$status"
}

restore_all() {
    local status=0

    restore_ohmyzsh || status=1
    restore_starship || status=1
    restore_tmux || status=1
    restore_ghostty || status=1
    restore_codium || status=1
    restore_rxfetch || status=1
    restore_colorls || status=1
    restore_btop || status=1
    return "$status"
}

help() {
    echo -e "Usage: ./main.sh 
\t[-h | --help]\t\tDisplay help
\t[-v | --version]\tDisplay version
\t[-a | --all]\t\tRestore all
\t[-o | --omz]\t\tRestore oh-my-zsh config (alias, functions)
\t[-s | --starship]\tRestore starship
\t[-r | --rxfetch]\tRestore rxfetch
\t[-c | --colorls]\tRestore colorls
\t[-tm | --tmux]\t\tRestore tmux
\t[-g | --ghostty]\tRestore Ghostty
\t[-co | --codium]\tRestore VSCodium
\t[-b | --btop]\t\tRestore btop
\t[-w | --wallpaper]\tRestore wallpaper
\t[-t | --test]\t\tCheck status
Shortcuts:
\t[-sc | --shortcreate]\tCreate shortcuts
\t[-sr | --shortrestore]\tRestore shortcuts"
}

version(){
    echo "v$current_version"
}


if [ "$#" -gt 2 ]; then
    echo "Error: Too many arguments provided."
    help
    exit 1
fi

if [ "$#" -ge 1 ]; then
    case "$1" in
        -h|--help)
            help
            exit 0
            ;;
        -v|--version)
            version
            exit 0
            ;;
        -a|--all)
            restore_all
            exit $?
            ;;
        -b|--btop)
            restore_btop
            exit $?
            ;;
        -o|--omz)
            restore_ohmyzsh
            exit $?
            ;;
        -s|--starship)
            restore_starship
            exit $?
            ;;
        -r|--rxfetch)
            restore_rxfetch
            exit $?
            ;;
        -c|--colorls)
            restore_colorls
            exit $?
            ;;
        -tm|--tmux)
            restore_tmux
            exit $?
            ;;
        -g|--ghostty)
            restore_ghostty
            exit $?
            ;;
        -co|--codium)
            restore_codium
            exit $?
            ;;
        -t|--test)
            check_status
            exit $?
            ;;
        -w|--wallpaper)
            restore_wallpaper
            exit 0
            ;;
        -sc|--shortcreate)
            create_shortcuts
            exit 0
            ;;
        -sr|--shortrestore)
            restore_shortcuts
            exit 0
            ;;
        *)
            echo "Error: Argument not found"
            help
            exit 1
            ;;
    esac
else
    echo "Error: 0 Argument"
    help
    exit 1
fi
