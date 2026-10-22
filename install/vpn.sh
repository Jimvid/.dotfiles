#!/bin/bash
# WireGuard profiles for NetworkManager, imported from ~/.config/wireguard/*.conf. The files hold
# private keys, so they stay out of this repo. The file name is the interface name; an optional
# "# Name = ..." comment in the file is the profile's display name. Profiles never autoconnect;
# NetworkManager keeps the key root-only. Safe to re-run.
set -e

# the profile whose tunnel interface is $1, if any
profile_for() {
    nmcli -t -f NAME,TYPE connection show | awk -F: '$2 == "wireguard" { print $1 }' | while read -r id; do
        if [ "$(nmcli -g connection.interface-name connection show "$id")" = "$1" ]; then echo "$id"; break; fi
    done
}

shopt -s nullglob
for conf in ~/.config/wireguard/*.conf; do
    iface=$(basename "$conf" .conf)
    name=$(sed -n 's/^# *Name *= *//p' "$conf" | head -1)
    id=$(profile_for "$iface")
    if [ -z "$id" ]; then
        nmcli connection import type wireguard file "$conf" >/dev/null
        nmcli connection modify "$iface" connection.autoconnect no
        id=$iface
        echo "vpn $iface: imported"
    fi
    [ -z "$name" ] || [ "$id" = "$name" ] || nmcli connection modify "$id" connection.id "$name"
done
