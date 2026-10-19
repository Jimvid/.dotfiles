import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import qs

// mixer: master volume for the default output, a device picker, and one slider per playing app
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
    implicitWidth: 320
    implicitHeight: card.implicitHeight

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio !== null)
    readonly property var streams: Pipewire.nodes.values.filter(n => n.isStream && n.isSink && n.audio !== null)   // playback streams are flagged isSink: they accept the app's audio
    PwObjectTracker { objects: popup.sinks.concat(popup.streams) }
    property bool showDevices: false

    // node.nick is the short human name ("Speaker", "HDMI 1"); the description is the full chipset mouthful
    function deviceName(node) { return node?.nickname || node?.description || "No output"; }
    function pct(node) { return Math.round((node?.audio?.volume ?? 0) * 100) + "%"; }
    function deviceIcon(node) {
        const s = ((node?.description ?? "") + " " + (node?.name ?? "")).toLowerCase();
        return s.includes("hdmi") || s.includes("displayport") ? "monitor-speaker"
             : s.includes("headphone") || s.includes("headset") ? "headphones" : "speaker";
    }
    function appName(node) { const p = node.properties ?? {}; return p["application.name"] || node.nickname || node.description || node.name; }
    function mediaName(node) { const p = node.properties ?? {}; return p["media.name"] ?? ""; }
    function appIcon(node) { const p = node.properties ?? {}; return Quickshell.iconPath(p["application.icon-name"] ?? "", true); }

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

            // master: device name (click to pick another output), mute, percentage, slider
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Icon { name: popup.deviceIcon(popup.sink); size: 16; color: popup.sink?.audio?.muted ? Theme.subtle : Theme.fg }
                Text {
                    Layout.fillWidth: true
                    text: popup.deviceName(popup.sink)
                    elide: Text.ElideRight
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                    MouseArea { anchors.fill: parent; enabled: popup.sinks.length > 1; onClicked: popup.showDevices = !popup.showDevices }
                }
                Icon {
                    visible: popup.sinks.length > 1
                    name: popup.showDevices ? "chevron-up" : "chevron-down"; size: 14; color: Theme.subtle
                    MouseArea { anchors.fill: parent; onClicked: popup.showDevices = !popup.showDevices }
                }
                Text {
                    text: popup.pct(popup.sink)
                    color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                }
                MuteButton { node: popup.sink }
            }
            VolumeSlider {
                Layout.fillWidth: true
                value: popup.sink?.audio?.volume ?? 0
                active: !(popup.sink?.audio?.muted ?? false)
                onMoved: v => { if (popup.sink?.audio) popup.sink.audio.volume = v; }
            }

            // device picker, folded away unless there is a choice
            ColumnLayout {
                visible: popup.showDevices && popup.sinks.length > 1
                Layout.fillWidth: true
                spacing: 2
                Repeater {
                    model: popup.sinks
                    delegate: Rectangle {
                        id: devRow
                        required property PwNode modelData
                        readonly property bool active: modelData === popup.sink
                        Layout.fillWidth: true
                        implicitHeight: 28
                        radius: Theme.fieldRadius
                        color: active ? Theme.highlightMed : devHover.containsMouse ? Theme.highlightLow : "transparent"
                        RowLayout {
                            anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                            spacing: 8
                            Icon { name: popup.deviceIcon(devRow.modelData); size: 14; color: devRow.active ? Theme.accent : Theme.subtle }
                            Text {
                                Layout.fillWidth: true
                                text: popup.deviceName(devRow.modelData)
                                elide: Text.ElideRight
                                color: devRow.active ? Theme.text : Theme.subtle
                                font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                            }
                            Icon { visible: devRow.active; name: "check"; size: 14; color: Theme.accent }
                        }
                        MouseArea {
                            id: devHover
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: { Pipewire.preferredDefaultAudioSink = devRow.modelData; popup.showDevices = false; }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.highlightMed }

            // one block per app with an output stream
            Repeater {
                model: popup.streams
                delegate: ColumnLayout {
                    id: app
                    required property PwNode modelData
                    readonly property bool muted: modelData.audio?.muted ?? false
                    readonly property string iconPath: popup.appIcon(modelData)
                    Layout.fillWidth: true
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Item {
                            implicitWidth: 16; implicitHeight: 16
                            Image {
                                anchors.fill: parent
                                visible: app.iconPath !== ""
                                source: app.iconPath
                                sourceSize: Qt.size(32, 32)
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                opacity: app.muted ? 0.5 : 1
                            }
                            Icon { anchors.fill: parent; visible: app.iconPath === ""; name: "audio-lines"; size: 16; color: app.muted ? Theme.subtle : Theme.fg }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                Layout.fillWidth: true
                                text: popup.appName(app.modelData)
                                elide: Text.ElideRight
                                color: app.muted ? Theme.subtle : Theme.text
                                font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                            }
                            Text {
                                Layout.fillWidth: true
                                visible: text !== "" && text !== popup.appName(app.modelData)
                                text: popup.mediaName(app.modelData)
                                elide: Text.ElideRight
                                color: Theme.muted; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 2
                            }
                        }
                        Text {
                            text: popup.pct(app.modelData)
                            color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                        }
                        MuteButton { node: app.modelData }
                    }
                    VolumeSlider {
                        Layout.fillWidth: true
                        value: app.modelData.audio?.volume ?? 0
                        active: !app.muted
                        onMoved: v => { if (app.modelData.audio) app.modelData.audio.volume = v; }
                    }
                }
            }

            Text {
                visible: popup.streams.length === 0
                text: "Nothing is playing"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }

    component MuteButton: Item {
        property PwNode node
        readonly property bool muted: node?.audio?.muted ?? false
        implicitWidth: 20; implicitHeight: 20
        Icon {
            anchors.centerIn: parent
            name: parent.muted ? "volume-x" : "volume-2"
            size: 14
            color: parent.muted ? Theme.love : muteHover.containsMouse ? Theme.text : Theme.subtle
        }
        MouseArea {
            id: muteHover
            anchors.fill: parent
            hoverEnabled: true
            onClicked: if (parent.node?.audio) parent.node.audio.muted = !parent.muted
        }
    }
}
