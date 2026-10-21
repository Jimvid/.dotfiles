import QtQuick
import qs

// WireGuard tunnels (Wireguard.qml); accent while one is up, hidden without any profiles
Glyph {
    id: root
    readonly property bool on: Wireguard.active.length > 0

    visible: Wireguard.profiles.length > 0
    icon: "shield"
    color: on ? Theme.accent : Theme.subtle
    tip: on ? Wireguard.active.map(p => p.name + (p.server ? "  ·  " + p.server : "")).join("\n") : "VPN off"

    // right click: drop every tunnel, or bring up the only one
    onClicked: mouse => {
        if (mouse.button !== Qt.RightButton) { popup.visible = !popup.visible; return; }
        if (on) Wireguard.active.forEach(p => Wireguard.down(p.name));
        else if (Wireguard.profiles.length === 1) Wireguard.up(Wireguard.profiles[0].name);
        else popup.visible = true;
    }
    VpnPopup { id: popup; target: root }
}
