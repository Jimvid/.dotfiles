import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs

Glyph {
    id: root
    readonly property var devices: Networking.devices.values
    readonly property var wifi: devices.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var primary: devices.find(d => d.type === DeviceType.Wifi && d.connected)
                                ?? devices.find(d => d.type === DeviceType.Wired && d.connected) ?? null
    readonly property var activeNetwork: primary?.networks?.values.find(n => n.connected) ?? null
    property string ip: ""

    icon: !primary ? "wifi-off" : primary.type === DeviceType.Wifi ? "wifi" : "ethernet-port"
    color: primary ? Theme.accent : Theme.subtle
    tip: !primary ? "disconnected"
       : primary.type === DeviceType.Wifi
         ? (activeNetwork?.name ?? "wifi") + (activeNetwork ? " (" + Math.round(activeNetwork.signalStrength * 100) + "%)" : "") + (ip ? "  |  " + ip : "")
         : primary.name + (ip ? "  |  " + ip : "")

    onClicked: popup.visible = !popup.visible
    NetworkPopup { id: popup; target: root; wifi: root.wifi }

    // the Networking module has no address property; ask the kernel
    Process {
        id: ipProc
        command: ["sh", "-c", "ip -j -4 addr show dev " + (root.primary?.name ?? "lo") + " 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.ip = JSON.parse(text)[0]?.addr_info?.[0]?.local ?? ""; } catch (e) { root.ip = ""; }
            }
        }
    }
    onPrimaryChanged: { ip = ""; if (primary) ipProc.running = true; }
    Timer { interval: 30000; repeat: true; running: root.primary !== null; onTriggered: ipProc.running = true }
}
