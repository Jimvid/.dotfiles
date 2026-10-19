import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import qs

PopupWindow {
    id: popup
    required property Item target
    property BluetoothAdapter adapter
    visible: false
    grabFocus: true

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away

    color: "transparent"
    implicitWidth: 280
    implicitHeight: card.implicitHeight

    readonly property var devices: adapter
        ? adapter.devices.values.filter(d => d.paired || d.connected).sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
        : []

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.highlightHigh
        implicitHeight: col.implicitHeight + 24

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: popup.adapter ? popup.adapter.name : "No adapter"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Toggle {
                    on: popup.adapter?.enabled ?? false
                    onToggled: if (popup.adapter) popup.adapter.enabled = !popup.adapter.enabled
                }
            }

            Repeater {
                model: popup.devices
                delegate: RowLayout {
                    required property BluetoothDevice modelData
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: modelData.name
                        elide: Text.ElideRight
                        color: modelData.connected ? Theme.text : Theme.subtle
                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                    Text {
                        visible: modelData.batteryAvailable
                        text: Math.round(modelData.battery * 100) + "%"
                        color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                    Toggle {
                        on: modelData.connected
                        onToggled: modelData.connected = !modelData.connected
                    }
                }
            }

            Text {
                visible: popup.devices.length === 0
                text: "No paired devices"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }
}
