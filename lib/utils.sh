check_command() {
    local command_name="$1"
    local display_name="${2:-$1}"

    if command -v "$command_name" >/dev/null 2>&1; then
        echo "✔ $display_name is installed"
        return 0
    fi

    echo "✖ $display_name is not installed"
    return 1
}

check_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "✔ oh-my-zsh is installed"
        return 0
    fi

    echo "✖ oh-my-zsh is not installed"
    return 1
}

check_nerdfonts() {
    if fc-list 2>/dev/null | grep -iq nerd; then
        echo "✔ nerd-fonts is installed"
        return 0
    fi

    echo "✖ nerd-fonts is not installed"
    return 1
}

check_starship() { check_command starship; }
check_rxfetch() { check_command rxfetch; }
check_colorls() { check_command colorls; }
check_tmux() { check_command tmux; }
check_ghostty() { check_command ghostty; }
check_codium() { check_command codium VSCodium; }
check_others() { check_command bat; }
check_btop() { check_command btop; }
