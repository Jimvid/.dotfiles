import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

PopupWindow {
    id: popup
    required property Item target
    visible: false
    grabFocus: true

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away

    color: "transparent"
    implicitWidth: 300
    implicitHeight: card.implicitHeight

    onVisibleChanged: if (visible) { Wireguard.refresh(); Wireguard.lookup(); }

    function bytes(n) {
        if (n < 1e6) return Math.round(n / 1e3) + " kB";
        if (n < 1e9) return (n / 1e6).toFixed(1) + " MB";
        return (n / 1e9).toFixed(2) + " GB";
    }

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

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "VPN"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Toggle { on: Wireguard.active.length > 0; onToggled: Wireguard.toggle() }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            Repeater {
                model: Wireguard.profiles
                delegate: Item {
                    id: row
                    required property var modelData
                    Layout.fillWidth: true
                    // the hover background bleeds into the card margin, so the text keeps the card's left edge
                    Layout.leftMargin: -8; Layout.rightMargin: -8
                    implicitHeight: content.implicitHeight + 12

                    // hover row, inset from the card edge
                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.cardRadius
                        color: area.containsMouse ? Theme.hover : "transparent"
                    }
                    RowLayout {
                        id: content
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 8; rightMargin: 8 }
                        spacing: 10

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            Text {
                                Layout.fillWidth: true
                                text: row.modelData.name
                                elide: Text.ElideRight
                                color: row.modelData.active ? Theme.accent : Theme.text
                                font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: row.modelData.active
                            }
                            Text {
                                text: [row.modelData.server, row.modelData.endpoint].filter(s => s).join("  ·  ")
                                color: Theme.muted; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 1
                            }
                            Text {
                                visible: row.modelData.active
                                text: row.modelData.address + "  ·  ↓ " + popup.bytes(row.modelData.rx) + "  ↑ " + popup.bytes(row.modelData.tx)
                                color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 1
                            }
                        }
                    }

                    // click to connect, click the connected one to disconnect, like the wifi list
                    MouseArea { id: area; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: Wireguard.select(row.modelData.name) }
                }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "Public IP"
                    color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                }
                Text {
                    text: Wireguard.publicIp || "—"
                    color: Theme.text; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                }
            }

            Text {
                visible: Wireguard.error !== ""
                Layout.fillWidth: true
                text: Wireguard.error
                wrapMode: Text.Wrap
                color: Theme.love; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }
}
