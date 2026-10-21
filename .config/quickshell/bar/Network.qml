import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs

// one glyph for whichever link is live: wifi, wired, or mobile data (Modem.qml)
Glyph {
    id: root
    readonly property var devices: Networking.devices.values
    readonly property var wifi: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var primary: devices.find(d => d.type === DeviceType.Wifi && d.connected)
                                ?? devices.find(d => d.type === DeviceType.Wired && d.connected) ?? null
    readonly property var activeNetwork: primary?.networks?.values.find(n => n.connected) ?? null
    readonly property bool mobile: !primary && Modem.connected
    readonly property string link: primary?.name ?? (mobile ? Modem.iface : "")
    property string ip: ""

    icon: primary ? (primary.type === DeviceType.Wifi ? "wifi" : "ethernet-port")
        : mobile ? "cell-" + (Modem.quality < 25 ? 1 : Modem.quality < 50 ? 2 : Modem.quality < 75 ? 3 : 4)
        : Modem.busy ? "cell-0"
        : "wifi-off"
    color: primary || mobile ? Theme.fg : Theme.subtle
    tip: primary
         ? (primary.type === DeviceType.Wifi
            ? (activeNetwork?.name ?? "Wi-Fi") + (activeNetwork ? " (" + Math.round(activeNetwork.signalStrength * 100) + "%)" : "")
            : primary.name) + (ip ? "  |  " + ip : "")
       : mobile ? Modem.operator + "  " + Modem.tech + " (" + Modem.quality + "%)" + (ip ? "  |  " + ip : "")
       : Modem.busy ? "Mobile data: working…"
       : "Disconnected"

    onClicked: popup.visible = !popup.visible
    NetworkPopup { id: popup; target: root; wifi: root.wifi; ip: root.ip }

    // the Networking module has no address property; ask the kernel
    Process {
        id: ipProc
        command: ["sh", "-c", "ip -j -4 addr show dev " + (root.link || "lo") + " 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.ip = JSON.parse(text)[0]?.addr_info?.[0]?.local ?? ""; } catch (e) { root.ip = ""; }
            }
        }
    }
    onLinkChanged: { ip = ""; if (link) ipProc.running = true; }
    Timer { interval: 30000; repeat: true; running: root.link !== ""; onTriggered: ipProc.running = true }
}
