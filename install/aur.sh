#!/bin/bash
# AUR packages. Requires yay (see yay.sh).
set -e

# docker-desktop ships its own compose and buildx plugins and refuses to install next to the standalone ones
pacman -Qq docker-compose docker-buildx networkmanager_dmenu 2>/dev/null | xargs -r sudo pacman -Rns --noconfirm

yay -S --needed --noconfirm \
    slack-desktop-wayland \
    plexamp-appimage \
    google-chrome \
    docker-desktop \
    1password \
    sddm-astronaut-theme
