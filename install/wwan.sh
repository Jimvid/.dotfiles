#!/bin/bash
# Quectel RM520N-GL (5G): the modem boots with its software radio off, the "FCC lock".
# ModemManager ships the unlock handshake for Quectel but only runs it when a link to the
# script exists under /etc/ModemManager/fcc-unlock.d named after the device id. Safe to re-run.
set -e

id=$(lspci -n -d 1eac: 2>/dev/null | awk '{print $3}' | head -1)
[ -n "$id" ] || { echo "no quectel modem, skipping"; exit 0; }

# modemmanager ships one entry per supported device id, all pointing at the quectel script
script=/usr/share/ModemManager/fcc-unlock.available.d/$id
link=/etc/ModemManager/fcc-unlock.d/$id
[ -e "$script" ] || { echo "modem $id: modemmanager has no fcc unlock script for it, skipping" >&2; exit 0; }

# only restart when the link changed: a restart drops a live mobile connection
changed=
if [ "$(readlink "$link" 2>/dev/null)" != "$script" ]; then
    sudo install -d /etc/ModemManager/fcc-unlock.d
    sudo ln -sfn "$script" "$link"
    changed=1
fi
sudo systemctl enable --now ModemManager.service
[ -z "$changed" ] || sudo systemctl restart ModemManager.service

# one NetworkManager profile for the sim; apn comes from the carrier database
nmcli -g NAME connection show | grep -qx wwan \
    || nmcli connection add type gsm ifname '*' con-name wwan gsm.auto-config yes connection.autoconnect no >/dev/null
echo "modem $id: fcc unlock enabled; connect with: nmcli connection up wwan"
