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

    // right click works the header switch
    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) Wireguard.toggle();
        else popup.visible = !popup.visible;
    }
    VpnPopup { id: popup; target: root }
}
