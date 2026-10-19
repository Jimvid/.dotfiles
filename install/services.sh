#!/bin/bash
set -e

sudo systemctl enable --now NetworkManager.service bluetooth.service power-profiles-daemon.service docker.service
sudo systemctl enable sddm.service
sudo install -d /etc/sddm.conf.d
printf '[Theme]\nCurrent=sddm-astronaut-theme\n' | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null
printf '[General]\nInputMethod=qtvirtualkeyboard\n' | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null
sudo install -Dm644 -t /usr/share/fonts/geist "$(dirname "$0")"/../.local/share/fonts/Geist-*.otf
printf '[General]\nBackground="/usr/share/backgrounds/dotfiles.jpg"\nFont="Geist"\n' |
    sudo tee /usr/share/sddm/themes/sddm-astronaut-theme/Themes/astronaut.conf.user >/dev/null

sudo usermod -aG docker,video "$USER"

xdg-user-dirs-update
