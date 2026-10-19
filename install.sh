#!/bin/bash
# every step is idempotent; re-run freely
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

step() { echo; echo "==> $1"; "install/$1"; }

step packages.sh
step yay.sh
step aur.sh
step services.sh

mkdir -p ~/dev/work ~/dev/personal ~/screenshots
./symlink.sh
step desktop.sh
~/.local/bin/wallpaper.sh wallpapers/tropic_island_night.jpg

step tools.sh
step zsh.sh
step node.sh

echo
echo "done. reboot into sddm and pick the Hyprland session."
