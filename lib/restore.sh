#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

source "$SCRIPT_DIR/utils.sh"

backup_existing() {
    local target="$1"
    local backup="${target}.backup"

    if [ -e "$target" ]; then
        if [ -e "$backup" ]; then
            backup="${backup}.$(date +%Y%m%d%H%M%S)"
        fi
        cp -a "$target" "$backup" || return 1
        echo "✔ Backup created: $backup"
    fi
}

copy_config() {
    local source_file="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"
    if [ -f "$target" ] && cmp -s "$source_file" "$target"; then
        echo "✔ Already current: $target"
        return 0
    fi

    backup_existing "$target" || return 1
    cp "$source_file" "$target" || return 1
    echo "✔ Restored: $target"
}

ensure_zsh_sources() {
    local zshrc="${ZDOTDIR:-$HOME}/.zshrc"
    local tools_path='.reconfig/bash_tools.sh'
    local config_path='.reconfig/config.sh'
    local add_tools=0
    local add_config=0

    mkdir -p "$(dirname "$zshrc")"
    touch "$zshrc"
    grep -Fq "$tools_path" "$zshrc" || add_tools=1
    grep -Fq "$config_path" "$zshrc" || add_config=1

    if [ "$add_tools" -eq 0 ] && [ "$add_config" -eq 0 ]; then
        return 0
    fi
    if [ -s "$zshrc" ]; then
        backup_existing "$zshrc" || return 1
    fi
    [ "$add_tools" -eq 0 ] || printf '\nsource "$HOME/%s"\n' "$tools_path" >> "$zshrc"
    [ "$add_config" -eq 0 ] || printf '\nsource "$HOME/%s"\n' "$config_path" >> "$zshrc"
}

create_tools() {
    local target_dir="$HOME/.reconfig"
    local tools_file="$target_dir/bash_tools.sh"
    local temp_file

    mkdir -p "$target_dir"
    temp_file="$(mktemp)"
    cat "$REPO_ROOT/config/aliases.sh" "$REPO_ROOT/config/functions.sh" > "$temp_file"
    copy_config "$temp_file" "$tools_file" || {
        rm -f "$temp_file"
        return 1
    }
    rm -f "$temp_file"

    copy_config "$REPO_ROOT/config/gradient.sh" "$target_dir/banner.sh" || return 1
    copy_config "$REPO_ROOT/config/oh-my-zsh/zshrc.sh" "$target_dir/config.sh" || return 1
    ensure_zsh_sources
}

create_starship() {
    copy_config "$REPO_ROOT/config/starship/starship.toml" "$CONFIG_HOME/starship.toml"
}

create_rxfetch() {
    local target="/usr/local/bin/rxfetch"

    copy_config "$REPO_ROOT/config/rxfetch/rxfetch" "$target"
    chmod +x "$target"
}

create_colorls() {
    backup_existing "$CONFIG_HOME/colorls" || return 1
    mkdir -p "$CONFIG_HOME/colorls"
    cp -r "$REPO_ROOT/config/colorls/." "$CONFIG_HOME/colorls/" || return 1
    echo "✔ Restored: $CONFIG_HOME/colorls"
}

create_tmux() {
    local target="$HOME/.tmux.conf"

    copy_config "$REPO_ROOT/config/tmux/.tmux.conf" "$target" || return 1
    if tmux list-sessions >/dev/null 2>&1; then
        tmux source-file "$target" || return 1
        echo "✔ Reloaded active tmux server"
    fi
}

create_ghostty() {
    copy_config "$REPO_ROOT/config/ghostty/config.ghostty" "$CONFIG_HOME/ghostty/config.ghostty"
}

create_codium() {
    local user_dir="$CONFIG_HOME/VSCodium/User"
    local extension
    local status=0

    copy_config "$REPO_ROOT/config/codium/settings.json" "$user_dir/settings.json" || return 1
    copy_config "$REPO_ROOT/config/codium/keybindings.json" "$user_dir/keybindings.json" || return 1
    copy_config \
        "$REPO_ROOT/config/codium/snippets/tailwind-snippets.code-snippets" \
        "$user_dir/snippets/tailwind-snippets.code-snippets" || return 1

    while IFS= read -r extension; do
        [ -n "$extension" ] || continue
        if ! codium --install-extension "$extension" >/dev/null; then
            echo "✖ Could not install VSCodium extension: $extension"
            status=1
        fi
    done < "$REPO_ROOT/config/codium/extensions.txt"
    if [ "$status" -eq 0 ]; then
        echo "✔ Restored VSCodium extensions"
    fi
    return "$status"
}

create_btop() {
    local target_dir="$CONFIG_HOME/btop"

    mkdir -p "$target_dir/themes"
    copy_config "$REPO_ROOT/config/btop/btop.conf" "$target_dir/btop.conf"
    copy_config "$REPO_ROOT/config/btop/gnome.theme" "$target_dir/themes/gnome.theme"
}

create_wallpaper() {
    local pictures_dir="$HOME/Pictures"
    local target="$pictures_dir/wallpaper_config.xml"

    mkdir -p "$pictures_dir"
    backup_existing "$pictures_dir/gradient" || return 1
    cp -r "$REPO_ROOT/backup/wallpapers/gradient" "$pictures_dir" || return 1
    backup_existing "$target" || return 1
    sed "s|PATH|$pictures_dir|g" "$REPO_ROOT/backup/wallpapers/gradient.xml.template" > "$target" || return 1
    echo "✔ Restored: $target"
}

restore_ohmyzsh() {
    check_ohmyzsh || return 1
    create_tools
}

restore_starship() {
    check_starship || return 1
    create_starship
}

restore_rxfetch() {
    check_rxfetch || return 1
    create_rxfetch
}

restore_colorls() {
    check_colorls || return 1
    create_colorls
}

restore_tmux() {
    check_tmux || return 1
    create_tmux
}

restore_ghostty() {
    check_ghostty || return 1
    create_ghostty
}

restore_codium() {
    check_codium || return 1
    create_codium
}

restore_btop() {
    check_btop || return 1
    create_btop
}

restore_wallpaper() {
    create_wallpaper
}
