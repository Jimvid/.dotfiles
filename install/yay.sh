#!/bin/bash
set -e

command -v yay >/dev/null && exit 0

tmp=$(mktemp -d)
git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
(cd "$tmp/yay-bin" && makepkg -si --noconfirm)
rm -rf "$tmp"
