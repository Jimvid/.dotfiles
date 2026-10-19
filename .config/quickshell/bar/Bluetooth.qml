import Quickshell.Bluetooth
import qs

Glyph {
    id: root
    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property var connected: Bluetooth.devices.values.filter(d => d.connected)

    icon: !adapter || !adapter.enabled ? "bluetooth-off" : connected.length > 0 ? "bluetooth-connected" : "bluetooth"
    color: !adapter || !adapter.enabled ? Theme.subtle : Theme.accent
    tip: !adapter ? "no bluetooth adapter"
       : !adapter.enabled ? "bluetooth off"
       : connected.length === 0 ? adapter.name + "\nno devices connected"
       : connected.map(d => d.name + (d.batteryAvailable ? "  " + Math.round(d.battery * 100) + "%" : "")).join("\n")

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) { if (adapter) adapter.enabled = !adapter.enabled; }
        else popup.visible = !popup.visible;
    }
    BluetoothPopup { id: popup; target: root; adapter: root.adapter }
}
