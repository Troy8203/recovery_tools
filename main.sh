#!/bin/bash

current_version="0.1.0"

#Import utils
source "$(dirname "$0")/./lib/utils.sh"
source "$(dirname "$0")/./lib/restore.sh"
source "$(dirname "$0")/./lib/shortcuts.sh"

check_status() {
    check_ohmyzsh
    check_nerdfonts
    check_starship
    check_rxfetch
    check_colorls
    check_others
    check_tmux
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
            restore_ohmyzsh
            restore_starship
            restore_rxfetch
            restore_colorls
            restore_tmux
            exit 0
            ;;
        -o|--omz)
            restore_ohmyzsh
            exit 0
            ;;
        -s|--starship)
            restore_starship
            exit 0
            ;;
        -r|--rxfetch)
            restore_rxfetch
            exit 0
            ;;
        -c|--colorls)
            restore_colorls
            exit 0
            ;;
        -tm|--tmux)
            restore_tmux
            exit 0
            ;;
        -t|--test)
            check_status
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