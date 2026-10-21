import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import qs

// bluetooth: adapter power, one row per paired device (click to connect or disconnect), and a scan for pairing new ones
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
    implicitWidth: 320
    implicitHeight: card.implicitHeight

    readonly property bool on: adapter?.enabled ?? false
    readonly property var all: adapter ? adapter.devices.values : []
    readonly property var paired: all.filter(d => d.paired || d.connected).sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
    readonly property var found: all.filter(d => !d.paired && !d.connected && d.name !== "").sort((a, b) => a.name.localeCompare(b.name))
    readonly property int connectedCount: paired.filter(d => d.connected).length

    // scanning stops with the popup; a closed popup should not keep the radio busy
    onVisibleChanged: if (!visible && adapter?.discovering) adapter.discovering = false

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
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
            spacing: 8

            // header: adapter, state, power
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Icon {
                    name: !popup.on ? "bluetooth-off" : popup.connectedCount > 0 ? "bluetooth-connected" : "bluetooth"
                    size: 16
                    color: popup.on ? Theme.fg : Theme.subtle
                }
                Text {
                    Layout.fillWidth: true
                    text: popup.adapter?.name ?? "No adapter"
                    elide: Text.ElideRight
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Toggle {
                    on: popup.on
                    onToggled: if (popup.adapter) popup.adapter.enabled = !popup.adapter.enabled
                }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            // paired devices
            ColumnLayout {
                visible: popup.on
                Layout.fillWidth: true
                spacing: 2
                Repeater {
                    model: popup.paired
                    delegate: BtDeviceRow {
                        onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                    }
                }
                Text {
                    visible: popup.paired.length === 0
                    Layout.leftMargin: 8
                    text: "No paired devices"
                    color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                }
            }
            Text {
                visible: !popup.on
                Layout.leftMargin: 8
                text: "Bluetooth is off"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }

            // scan: found devices appear below, click one to pair
            ColumnLayout {
                visible: popup.on
                Layout.fillWidth: true
                spacing: 2
                Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

                Rectangle {
                    id: scanRow
                    Layout.fillWidth: true
                    // the hover background bleeds into the card margin, so the text keeps the card's left edge
                    Layout.leftMargin: -8; Layout.rightMargin: -8
                    implicitHeight: 30
                    radius: Theme.cardRadius
                    color: scanHover.containsMouse ? Theme.hover : "transparent"
                    readonly property bool scanning: popup.adapter?.discovering ?? false
                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        spacing: 8
                        Icon {
                            id: scanIcon
                            name: scanRow.scanning ? "loader-circle" : "search"; size: 14
                            color: scanRow.scanning ? Theme.accent : Theme.subtle
                            RotationAnimation on rotation { running: scanRow.scanning; from: 0; to: 360; duration: 1000; loops: Animation.Infinite }
                            onNameChanged: rotation = 0
                        }
                        Text {
                            Layout.fillWidth: true
                            text: scanRow.scanning ? "Scanning for devices…" : "Scan for devices"
                            color: scanRow.scanning ? Theme.text : Theme.subtle
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                        }
                        Text {
                            visible: scanRow.scanning
                            text: "stop"
                            color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 1
                        }
                    }
                    MouseArea {
                        id: scanHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (popup.adapter) popup.adapter.discovering = !popup.adapter.discovering
                    }
                }

                Repeater {
                    model: popup.found
                    delegate: BtDeviceRow {
                        onClicked: if (!modelData.pairing) modelData.pair()
                    }
                }
            }
        }
    }
}
