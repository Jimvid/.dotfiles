import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs

PopupWindow {
    id: popup
    required property Item target
    property var wifi
    visible: false

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 6

    color: "transparent"
    implicitWidth: 300
    implicitHeight: card.implicitHeight

    // scan only while open
    onVisibleChanged: if (wifi) wifi.scannerEnabled = visible

    readonly property var networks: wifi
        ? wifi.networks.values.slice().sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength))
        : []
    property var pskFor: null   // network waiting for a passphrase
    property string error: ""

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.overlay
        implicitHeight: col.implicitHeight + 24

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "wi-fi"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Toggle { on: Networking.wifiEnabled; onToggled: Networking.wifiEnabled = !Networking.wifiEnabled }
            }

            Repeater {
                model: popup.networks
                delegate: ColumnLayout {
                    id: row
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 4

                    Connections {
                        target: row.modelData
                        function onConnectionFailed(reason) {
                            if (reason === ConnectionFailReason.NoSecrets) { popup.pskFor = row.modelData; popup.error = ""; }
                            else popup.error = "connection failed";
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: row.modelData.signalStrength > 0.66 ? "\uf1eb" : row.modelData.signalStrength > 0.33 ? "\uf1eb" : "\uf1eb"
                            opacity: 0.4 + 0.6 * row.modelData.signalStrength
                            color: Theme.accent; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                        }
                        Text {
                            Layout.fillWidth: true
                            text: row.modelData.name
                            elide: Text.ElideRight
                            color: row.modelData.connected ? Theme.text : Theme.subtle
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: row.modelData.connected
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    popup.error = "";
                                    if (row.modelData.connected) row.modelData.disconnect();
                                    else if (!row.modelData.known && row.modelData.security !== WifiSecurityType.Open) popup.pskFor = row.modelData;
                                    else { popup.pskFor = null; row.modelData.connect(); }
                                }
                            }
                        }
                        Text {
                            visible: row.modelData.security !== WifiSecurityType.Open
                            text: "\uf023"
                            color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                        }
                    }

                    TextField {
                        visible: popup.pskFor === row.modelData
                        Layout.fillWidth: true
                        echoMode: TextInput.Password
                        placeholderText: "passphrase"
                        color: Theme.text
                        placeholderTextColor: Theme.muted
                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                        background: Rectangle { radius: 6; color: Theme.base; border.width: 1; border.color: Theme.overlay }
                        onVisibleChanged: if (visible) forceActiveFocus()
                        onAccepted: { row.modelData.connectWithPsk(text); text = ""; popup.pskFor = null; }
                    }
                }
            }

            Text {
                visible: popup.error !== ""
                text: popup.error
                color: Theme.love; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
            Text {
                visible: popup.networks.length === 0
                text: Networking.wifiEnabled ? "scanning\u2026" : "wi-fi is off"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }
}
