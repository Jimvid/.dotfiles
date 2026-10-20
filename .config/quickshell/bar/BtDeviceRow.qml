import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import qs

// one bluetooth device in the popup: type icon, name, battery, state; a connected device gets the accent check like the active output in the mixer
Rectangle {
    id: row
    required property var modelData
    readonly property BluetoothDevice device: modelData
    signal clicked()

    function deviceIcon(d) {
        const i = (d.icon ?? "").toLowerCase();
        return i.includes("head") ? "headphones"
             : i.includes("speaker") || i.includes("audio") ? "speaker"
             : i.includes("mouse") ? "mouse"
             : i.includes("keyboard") ? "keyboard"
             : i.includes("gaming") ? "gamepad"
             : i.includes("phone") ? "smartphone"
             : i.includes("watch") ? "watch"
             : "bluetooth";
    }
    function batteryIcon(d) { return d.battery > 0.8 ? "battery-full" : d.battery > 0.45 ? "battery-medium" : d.battery > 0.15 ? "battery-low" : "battery"; }
    readonly property string busy: device.pairing ? "Pairing…"
                                 : device.state === BluetoothDeviceState.Connecting ? "Connecting…"
                                 : device.state === BluetoothDeviceState.Disconnecting ? "Disconnecting…"
                                 : ""

    Layout.fillWidth: true
    implicitHeight: 30
    radius: Theme.fieldRadius
    color: device.connected ? Theme.highlightMed : hover.containsMouse ? Theme.highlightLow : "transparent"

    RowLayout {
        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
        spacing: 8
        Icon { name: row.deviceIcon(row.device); size: 14; color: row.device.connected ? Theme.accent : Theme.subtle }
        Text {
            Layout.fillWidth: true
            text: row.device.name
            elide: Text.ElideRight
            color: row.device.connected ? Theme.text : Theme.subtle
            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
        }
        Text {
            visible: row.busy !== ""
            text: row.busy
            color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 1
        }
        RowLayout {
            visible: row.device.batteryAvailable && row.busy === ""
            spacing: 4
            Icon { name: row.batteryIcon(row.device); size: 13; color: Theme.subtle }
            Text {
                text: Math.round(row.device.battery * 100) + "%"
                color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 1
            }
        }
        Icon { visible: row.device.connected; name: "check"; size: 14; color: Theme.accent }
    }
    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: row.clicked()
    }
}
