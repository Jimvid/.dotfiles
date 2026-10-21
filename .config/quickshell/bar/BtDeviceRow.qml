import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import qs

// one bluetooth device in the popup: type icon, name, battery, state; a connected device is named in the accent
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

    // the hover background bleeds into the card margin, so the text keeps the card's left edge

    Layout.leftMargin: -8; Layout.rightMargin: -8
    implicitHeight: 30
    // hover row, inset from the card edge
    radius: Theme.cardRadius
    color: hover.containsMouse ? Theme.hover : "transparent"

    RowLayout {
        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
        spacing: 8
        Icon { name: row.deviceIcon(row.device); size: 14; color: row.device.connected ? Theme.accent : Theme.subtle }
        Text {
            Layout.fillWidth: true
            text: row.device.name
            elide: Text.ElideRight
            color: row.device.connected ? Theme.accent : Theme.text
            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: row.device.connected
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
    }
    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: row.clicked()
    }
}
