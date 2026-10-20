#!/bin/bash
# Quectel RM520N-GL (5G): the modem boots with its software radio off, the "FCC lock".
# ModemManager ships the unlock handshake for Quectel but only runs it when a link to the
# script exists under /etc/ModemManager/fcc-unlock.d named after the device id. Safe to re-run.
set -e

id=$(lspci -n -d 1eac: 2>/dev/null | awk '{print $3}' | head -1)
[ -n "$id" ] || { echo "no quectel modem, skipping"; exit 0; }

sudo install -d /etc/ModemManager/fcc-unlock.d
sudo ln -sfn /usr/share/ModemManager/fcc-unlock.available.d/1eac "/etc/ModemManager/fcc-unlock.d/$id"
sudo systemctl enable --now ModemManager.service
sudo systemctl restart ModemManager.service

# one NetworkManager profile for the sim; apn comes from the carrier database
nmcli -g NAME connection show | grep -qx wwan \
    || nmcli connection add type gsm ifname '*' con-name wwan gsm.auto-config yes connection.autoconnect no >/dev/null
echo "modem $id: fcc unlock enabled; connect with: nmcli connection up wwan"
