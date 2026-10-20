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

create_lsd() {
    copy_config "$REPO_ROOT/config/lsd/icons.yaml" "$CONFIG_HOME/lsd/icons.yaml"
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

ensure_opencode_completion() {
    local completion_dir="$HOME/.zsh/completions"
    local completion_file="$completion_dir/_opencode"
    local completion_tmp
    local zshrc="${ZDOTDIR:-$HOME}/.zshrc"
    local zshrc_tmp

    mkdir -p "$completion_dir" "$(dirname "$zshrc")"
    completion_tmp="$(mktemp)"
    if ! opencode --completions zsh > "$completion_tmp" || [ ! -s "$completion_tmp" ]; then
        rm -f "$completion_tmp"
        echo "✖ Could not generate OpenCode Zsh completions"
        return 1
    fi
    copy_config "$completion_tmp" "$completion_file" || {
        rm -f "$completion_tmp"
        return 1
    }
    rm -f "$completion_tmp"

    touch "$zshrc"
    if grep -Fq '.zsh/completions' "$zshrc"; then
        return 0
    fi

    if [ -s "$zshrc" ]; then
        backup_existing "$zshrc" || return 1
    fi
    zshrc_tmp="$(mktemp)"
    awk '
        !added && /source .*oh-my-zsh\.sh/ {
            print "# OpenCode completions (before Oh My Zsh initializes compinit)."
            print "fpath=(\"$HOME/.zsh/completions\" $fpath)"
            added=1
        }
        { print }
        END {
            if (!added) {
                print ""
                print "# OpenCode completions"
                print "fpath=(\"$HOME/.zsh/completions\" $fpath)"
                print "autoload -Uz compinit"
                print "compinit"
            }
        }
    ' "$zshrc" > "$zshrc_tmp" || {
        rm -f "$zshrc_tmp"
        return 1
    }
    cp "$zshrc_tmp" "$zshrc" || {
        rm -f "$zshrc_tmp"
        return 1
    }
    rm -f "$zshrc_tmp"
    echo "✔ Enabled OpenCode Zsh completions in $zshrc"
}

create_opencode() {
    local target_dir="$CONFIG_HOME/opencode"
    local opencode_config="$target_dir/opencode.jsonc"
    local cli_config="$target_dir/cli.json"
    local cli_tmp
    local notifier_package='@mohak34/opencode-notifier@latest'

    mkdir -p "$target_dir"

    if [ ! -f "$opencode_config" ] || ! grep -Fq '@mohak34/opencode-notifier' "$opencode_config"; then
        backup_existing "$opencode_config" || return 1
        opencode plugin add "$notifier_package" || return 1
        echo "✔ Added OpenCode notifier without replacing existing providers or models"
    else
        echo "✔ OpenCode notifier is already configured"
    fi

    if [ ! -e "$cli_config" ]; then
        copy_config "$REPO_ROOT/config/opencode/cli-notifications.json" "$cli_config" || return 1
    else
        if ! command -v jq >/dev/null 2>&1; then
            echo "✖ jq is required to preserve and merge the existing OpenCode CLI settings"
            return 1
        fi
        if ! jq empty "$cli_config" >/dev/null 2>&1; then
            echo "✖ Existing OpenCode CLI settings are not valid JSON: $cli_config"
            return 1
        fi
        if ! jq -e '
            (.plugins // []) as $plugins |
            ($plugins | index("*")) != null and
            ($plugins | index("-opencode.notifications")) != null
        ' "$cli_config" >/dev/null; then
            backup_existing "$cli_config" || return 1
            cli_tmp="$(mktemp)"
            jq '
                .plugins = (
                    ["*"] +
                    ((.plugins // []) | map(select(. != "*" and . != "-opencode.notifications"))) +
                    ["-opencode.notifications"]
                )
            ' "$cli_config" > "$cli_tmp" || {
                rm -f "$cli_tmp"
                return 1
            }
            cp "$cli_tmp" "$cli_config" || {
                rm -f "$cli_tmp"
                return 1
            }
            rm -f "$cli_tmp"
            echo "✔ Merged notification settings into $cli_config"
        else
            echo "✔ OpenCode CLI notification settings are already configured"
        fi
    fi

    copy_config "$REPO_ROOT/config/opencode/opencode-notifier.json" "$target_dir/opencode-notifier.json" || return 1
    ensure_opencode_completion || return 1

    echo "✔ OpenCode notifier is installed and configured"
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

restore_lsd() {
    check_lsd || return 1
    create_lsd
}

restore_tmux() {
    check_tmux || return 1
    create_tmux
}

restore_ghostty() {
    check_ghostty || return 1
    create_ghostty
}

restore_opencode() {
    check_opencode || return 1
    create_opencode
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
