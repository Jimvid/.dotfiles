#!/usr/bin/env bash
# Directories are linked whole; a file is linked on its own when its parent dir
# also holds things that must stay out of the repo (herdr logs/sockets, installed binaries).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

links=(
    .zshrc
    .gitconfig
    .gitignore
    .config/dunst
    .config/fontconfig
    .config/gtk-3.0/settings.ini
    .config/gtk-4.0/settings.ini
    .config/ghostty
    .config/hypr
    .config/kanshi
    .config/networkmanager-dmenu
    .config/nvim
    .config/rofi
    .config/waybar
    .config/zed
    .config/herdr/config.toml
    .local/share/fonts
    wallpapers
)
for f in "$DOTFILES"/.local/bin/*.sh; do
    links+=(".local/bin/$(basename "$f")")
done

link() {
    local rel=$1 src="$DOTFILES/$1" dst="$HOME/$1" parent
    parent=$(dirname "$dst")

    if [[ -L $parent ]]; then
        echo "error: $parent is itself a symlink; remove it and re-run" >&2
        exit 1
    fi

    if [[ -L $dst ]]; then
        if [[ $(readlink "$dst") == "$src" ]]; then
            echo "ok      $rel"
            return
        fi
        rm "$dst"
    elif [[ -e $dst ]]; then
        mv "$dst" "$dst.bak"
        echo "backup  $rel -> $rel.bak"
    fi

    mkdir -p "$parent"
    ln -s "$src" "$dst"
    echo "linked  $rel"
}

for l in "${links[@]}"; do
    link "$l"
done
