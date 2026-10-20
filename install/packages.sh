#!/bin/bash
set -e

# replaced: uwsm (second sddm entry), waybar (quickshell bar)
pacman -Qq uwsm waybar 2>/dev/null | xargs -r sudo pacman -Rns --noconfirm

sudo pacman -S --needed --noconfirm \
    `# base system` \
    base base-devel linux linux-firmware amd-ucode efibootmgr \
    btrfs-progs snapper zram-generator smartmontools \
    networkmanager iwd modemmanager wireless_tools bluez bluez-utils \
    power-profiles-daemon powertop \
    `# graphics` \
    intel-media-driver libva-intel-driver vulkan-intel vulkan-radeon vulkan-nouveau \
    xf86-video-amdgpu xf86-video-ati xf86-video-nouveau xorg-server xorg-xinit \
    `# audio` \
    pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber libpulse \
    gst-plugin-pipewire sof-firmware \
    `# desktop (hyprland)` \
    hyprland hypridle hyprlock hyprpaper hyprpicker hyprsunset sddm fprintd \
    rofi libnotify kanshi playerctl quickshell qt6-svg \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-utils xdg-user-dirs \
    qt5-wayland qt6-wayland qt6-virtualkeyboard \
    grim slurp wl-clipboard cliphist brightnessctl python-pillow \
    thunar thunar-volman gvfs adwaita-icon-theme \
    noto-fonts noto-fonts-emoji gsettings-desktop-schemas \
    `# terminal and shell` \
    ghostty zsh neovim vim nano \
    `# cli tools` \
    git openssh github-cli lazygit fzf ripgrep fd zoxide jq lsd tree btop wget unzip man-db \
    go go-task opentofu rustup just docker \
    `# flutter (fvm installs the sdk, see tools.sh)` \
    clang cmake ninja pkgconf gtk3 glu xz zip chromium \
    `# apps` \
    firefox zed gimp
