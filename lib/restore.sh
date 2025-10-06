#!/usr/bin/env bash

#Import utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_PATH=$(pwd)
source "$SCRIPT_DIR/utils.sh"

create_tools() {
    local path="$HOME/.reconfig"
    rm -rdf "$HOME/.reconfig"
    mkdir -p "$HOME/.reconfig"

    file_zshrc="$HOME/.zshrc"
    file_path="$path/bash_tools.sh"
    file_config="$path/config.sh"
    file_banner="$path/banner.sh"

    #Create bash_tools.sh
    cat "$CURRENT_PATH/config/aliases.sh"  > "$file_path" 
    cat "$CURRENT_PATH/config/functions.sh" >> "$file_path"

    #Create banner.sh
    cat "$CURRENT_PATH/config/gradient.sh"  > "$file_banner"

    if [ -e "$file_path" ]; then
        echo "✔ bash_tools.sh was created"
    else
        echo "✖ bash_tools.sh was not created" 
    fi

    #Create config.sh
    cat "$CURRENT_PATH/config/oh-my-zsh/zshrc.sh"  > "$file_config"

    if [ -e "$file_config" ]; then
        echo "✔ config.sh was created"
    else
        echo "✖ config.sh was not created" 
    fi

    # Add to zshrc
    echo "# .reconfig files import" >> "$file_zshrc"
    echo "source $file_path" >> "$file_zshrc"
    echo "source $file_config" >> "$file_zshrc"

    #Reload zshrc
    #source ~/.zshrc
}

create_startship() {
    local file_path="$HOME/.config"
    local file_starship="$file_path/starship.toml"

    mkdir -p "$file_path"
    cat "$CURRENT_PATH/config/starship/starship.toml" > "$file_starship"
}

create_rxfetch() {
    local file_path="/usr/local/bin/"
    local file_rxfetch="$file_path/rxfetch"

    mkdir -p "$file_path"
    cat "$CURRENT_PATH/config/rxfetch/rxfetch" > "$file_rxfetch"
    chmod +x "$file_rxfetch"

    if [ -e "$file_rxfetch" ]; then
        echo "✔ rxfetch was created"
    else
        echo "✖ rxfetch was not created" 
    fi
}

create_colorls() {
    local file_path="$HOME/.config"

    mkdir -p "$file_path/colorls"
    cp -r "$CURRENT_PATH/config/colorls/" "$file_path"

    if [[ -d "$file_path/colorls" && -e "$file_path/colorls/file_aliases.yaml" && -e "$file_path/colorls/files.yaml" && -e "$file_path/colorls/folders.yaml" ]]; then
        echo "✔ colorls was created"
    else
        echo "✖ colorls was not created" 
    fi
}

create_tmux() {
    local file_path="$HOME"
    local file_tmux="$file_path/.tmux.conf"

    cat "$CURRENT_PATH/config/tmux/.tmux.conf" > "$file_tmux"

    if [ -e "$file_tmux" ]; then
        echo "✔ tmux was created"
        tmux source-file "$file_tmux"
    else
        echo "✖ tmux was not created" 
    fi
}

create_btop() {
    local file_path="$HOME/.config/btop"
    local file_config="$file_path/btop/btop.conf"
    local file_theme="$file_path/themes/gnome.theme"

    cat "$CURRENT_PATH/config/btop/btop.conf" > "$file_config"
    cat "$CURRENT_PATH/config/btop/gnome.theme" > "$file_theme"

    if [ -e "$file_config" && -e "$file_theme" ]; then
        echo "✔ btop was created"
    else
        echo "✖ btop was not created" 
    fi
}

create_wallpaper() {
    local file_path="$HOME/Pictures"
    local file_wallpaper="$file_path/wallpaper_config.xml"

    cp -r "$CURRENT_PATH/backup/wallpapers/gradient" "$file_path"

    sed "s|PATH|$file_path|g" "$CURRENT_PATH/backup/wallpapers/gradient.xml.template" > "$file_wallpaper"

    if [ -e "$file_wallpaper" ]; then
        echo "✔ wallpaper_config.xml was created"
    else
        echo "✖ wallpaper_config.xml was not created" 
    fi
}


restore_ohmyzsh() {
    if check_ohmyzsh ; then
        echo -e "\nInstall this plugins:"
        echo "- zsh-syntax-highlighting"
        echo "- zsh-autosuggestions"
        create_tools
        exit 0
    else
        echo "Is no possible to restore oh-my-zsh"
        exit 1
    fi
}

restore_starship() {
    if check_starship ; then
        create_startship
        exit 0
    else
        echo "Is no possible to restore starship"
        echo "Create the file ~/.config/starship.toml"
        echo "Run touch ~/.config/starship.toml"
        exit 1
    fi
}

restore_rxfetch() {
    if check_rxfetch ; then
        create_rxfetch
        exit 0
    else
        echo "Is no possible to restore rxfetch"
        exit 1
    fi
}

restore_colorls() {
    if check_colorls ; then
        create_colorls
        exit 0
    else
        echo "Is no possible to restore colorls"
        exit 1
    fi
}

restore_tmux() {
    if check_tmux ; then
        create_tmux
        exit 0
    else
        echo "Is no possible to restore tmux"
        exit 1
    fi
}

restore_btop() {
    if check_btop ; then
        create_btop
        exit 0
    else
        echo "Is no possible to restore btop"
        exit 1
    fi
}

restore_wallpaper() {
    create_wallpaper
}