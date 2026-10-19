#!/bin/bash
# GTK4 reads fonts via the settings portal (gsettings), not settings.ini
set -e

# gsettings needs the user session bus; on a bare tty without one, defer to the next login
[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] || { echo "no session bus, re-run install/desktop.sh after logging in"; exit 0; }

gsettings set org.gnome.desktop.interface color-scheme prefer-dark   # ghostty and gtk apps pick their dark theme from this
gsettings set org.gnome.desktop.interface font-name 'Geist 11'
gsettings set org.gnome.desktop.interface document-font-name 'Geist 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'GeistMono Nerd Font Mono 11'
