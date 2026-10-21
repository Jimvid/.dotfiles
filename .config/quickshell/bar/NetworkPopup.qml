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
    property string ip: ""
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
    onVisibleChanged: {
        if (wifi) wifi.scannerEnabled = visible;
        if (visible) Modem.refresh();
    }

    // sorted by strength, rebuilt on a tick and only when the order changed, so the Repeater keeps its
    // rows (each with a shader-tinted icon) while strengths fluctuate
    property var networks: []
    readonly property int count: wifi?.networks.values.length ?? 0
    onCountChanged: rebuild()
    function rebuild() {
        const list = (wifi ? wifi.networks.values.slice() : [])
            .sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength));
        if (list.length === networks.length && list.every((n, i) => n === networks[i])) return;
        networks = list;
    }
    Timer { running: popup.visible; interval: 2000; repeat: true; triggeredOnStart: true; onTriggered: popup.rebuild() }

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
                Toggle {
                    on: Networking.wifiEnabled
                    onToggled: { popup.error = ""; popup.pskFor = null; Networking.wifiEnabled = !Networking.wifiEnabled; }
                }
            }

            // the list only exists while wifi is on; off, the header goes straight to the mobile section
            Rectangle { visible: Networking.wifiEnabled; Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

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
                visible: Networking.wifiEnabled && popup.networks.length === 0
                text: "Scanning\u2026"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }

            // mobile data, only with a modem (Modem.qml)
            Rectangle { visible: Modem.present; Layout.fillWidth: true; Layout.topMargin: 8; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            RowLayout {
                visible: Modem.present
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "Mobile data"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Toggle { on: Modem.connected; onToggled: Modem.connected ? Modem.disable() : Modem.enable() }
            }

            Repeater {
                model: Modem.connected ? [
                    ["Operator", Modem.operator || "\u2014"],
                    ["Network", Modem.tech + "  " + Modem.quality + "%"],
                    ["Address", popup.ip || "\u2014"],
                ] : []
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text {
                        Layout.fillWidth: true
                        text: modelData[0]
                        color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                    Text {
                        text: modelData[1]
                        color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                }
            }

            Text {
                visible: Modem.error !== ""
                Layout.fillWidth: true
                text: Modem.error
                wrapMode: Text.Wrap
                color: Theme.love; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }
}
