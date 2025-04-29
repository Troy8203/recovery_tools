#Check if oh-my-zsh is installed
check_ohmyzsh() {
    if [ -e "$HOME/.oh-my-zsh" ]; then
        echo "✔ oh-my-zsh was installed"
        return 0
    else
        echo "✖ oh-my-zsh is not installed"
        return 1
    fi
}

#Check if nerd-fonts is installed
check_nerdfonts() {
    if fc-list | grep -iq nerd; then
        echo "✔ nerd-fonts was installed"
        return 0
    else
        echo "✖ nerd-fonts is not installed"
        return 1
    fi
}

#Check if starship is installed
check_starship() {
    if [ -e "$HOME/.config/starship.toml" ]; then
        echo "✔ starship was installed"
        return 0
    else
        echo "✖ starship is not installed"
        return 1
    fi
}

#Check if rxfetch is installed
check_rxfetch() {
    if rxfetch -v ls >/dev/null 2>&1; then
        echo "✔ rxfetch was installed"
        return 0
    else
        echo "✖ rxfetch is not installed"
        return 1
    fi
}

#Check if colorls is installed
check_colorls() {
    if colorls --version ls >/dev/null 2>&1; then
        echo "✔ colorls was installed"
        return 0
    else
        echo "✖ colorls is not installed"
        return 1
    fi
}

#Check if bat is installed
check_bat() {
    if bat --version ls >/dev/null 2>&1; then
        echo "✔ bat was installed"
        return 0
    else
        echo "✖ bat is not installed"
        return 1
    fi
}