#!/bin/bash
# every step is idempotent; re-run freely
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# flags
#   --skip-docker-desktop   plain docker with the compose and buildx plugins instead of docker desktop

export SKIP_DOCKER_DESKTOP=0
for arg in "$@"; do
    case "$arg" in
        --skip-docker-desktop) SKIP_DOCKER_DESKTOP=1 ;;
        -h|--help) sed -n '/^# flags/,/^$/p' "$0"; exit 0 ;;
        *) echo "unknown flag: $arg" >&2; exit 2 ;;
    esac
done

step() { echo; echo "==> $1"; "install/$1"; }

step packages.sh
step yay.sh
step aur.sh
step services.sh
step wwan.sh

mkdir -p ~/dev/work ~/dev/personal ~/screenshots
./symlink.sh
step desktop.sh
~/.local/bin/wallpaper.sh wallpapers/tropic_island_night.jpg

step tools.sh
step zsh.sh
step node.sh

echo
echo "done. reboot into sddm and pick the Hyprland session."
