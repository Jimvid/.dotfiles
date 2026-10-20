#!/bin/bash
# select an area, save it to ~/screenshots, copy it to the clipboard and say where it went. esc in slurp aborts quietly
set -euo pipefail
dir=$HOME/screenshots
mkdir -p "$dir"
file=$dir/screenshot_$(date +%Y%m%d_%H%M%S).png
# rose pine: dim the screen with base, gold border and a faint gold fill on the selection
area=$(slurp -b 19172499 -c f6c177ff -s f6c17726 -w 2 -F Geist) || exit 0
grim -g "$area" "$file"
wl-copy --type image/png < "$file"
notify-send -a Screenshot -i "$file" "Screenshot saved" "copied to clipboard\n$file"
