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
    grabFocus: true

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away

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
                    text: "Wi-Fi"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Toggle { on: Networking.wifiEnabled; onToggled: Networking.wifiEnabled = !Networking.wifiEnabled }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

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
                            else popup.error = "Connection failed";
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Icon {
                            name: "wifi"; size: 14
                            opacity: 0.4 + 0.6 * row.modelData.signalStrength
                            color: Theme.fg
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
                        Icon {
                            visible: row.modelData.security !== WifiSecurityType.Open
                            name: "lock"; size: 12; color: Theme.subtle
                        }
                    }

                    TextField {
                        visible: popup.pskFor === row.modelData
                        Layout.fillWidth: true
                        echoMode: TextInput.Password
                        placeholderText: "Passphrase"
                        color: Theme.text
                        placeholderTextColor: Theme.muted
                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                        background: Rectangle { radius: Theme.fieldRadius; color: Theme.base; border.width: 1; border.color: Theme.highlightHigh }
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
                text: Networking.wifiEnabled ? "Scanning\u2026" : "Wi-Fi is off"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }
}
