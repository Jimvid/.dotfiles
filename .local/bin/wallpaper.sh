#!/usr/bin/env bash
# Set the wallpaper for both hyprland (hyprpaper) and the sddm login screen.
#   wallpaper.sh <image>
set -euo pipefail

src=${1:?usage: wallpaper.sh <image>}
[[ -f $src ]] || { echo "no such file: $src" >&2; exit 1; }

name=$(basename "$src")
dest=~/wallpapers/$name
[[ $(realpath "$src") == $(realpath -m "$dest") ]] || cp "$src" "$dest"

# hyprpaper: persist, then hot-swap if it is running
conf=~/.config/hypr/hyprpaper.conf
sed -i "s|^\(\s*path = \).*|\1~/wallpapers/$name|" "$conf"
if [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]] && pidof hyprpaper >/dev/null; then
    hyprctl hyprpaper wallpaper ", $dest, cover" >/dev/null
fi

# sddm greeter runs as its own user, so it reads a copy under /usr/share
sudo install -Dm644 "$dest" /usr/share/backgrounds/dotfiles.jpg
echo "wallpaper: $dest (login screen updates on next boot)"
