#!/bin/bash
# AUR packages. Requires yay (see yay.sh).
set -e

# docker: either docker desktop (which ships its own compose and buildx plugins and refuses to install next to the
# standalone ones) or, with install.sh --skip-docker-desktop, the standalone plugins from the repos
if [[ ${SKIP_DOCKER_DESKTOP:-0} == 1 ]]; then
    pacman -Qq docker-desktop 2>/dev/null | xargs -r sudo pacman -Rns --noconfirm
    sudo pacman -S --needed --noconfirm docker-compose docker-buildx
    docker_desktop=()
else
    pacman -Qq docker-compose docker-buildx 2>/dev/null | xargs -r sudo pacman -Rns --noconfirm
    docker_desktop=(docker-desktop)
fi
pacman -Qq networkmanager_dmenu 2>/dev/null | xargs -r sudo pacman -Rns --noconfirm

yay -S --needed --noconfirm \
    slack-desktop \
    plexamp-appimage \
    google-chrome \
    "${docker_desktop[@]}" \
    1password \
    sddm-astronaut-theme \
    ripdrag
