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
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property var sources: Pipewire.nodes.values.filter(n => !n.isSink && !n.isStream && n.audio !== null && !(n.name ?? "").endsWith(".monitor"))
    readonly property var captures: Pipewire.nodes.values.filter(n => n.isStream && !n.isSink && n.audio !== null)   // apps recording
    PwObjectTracker { objects: popup.sinks.concat(popup.streams, popup.sources, popup.captures) }
    property bool showDevices: false
    property bool showInputs: false

    // node.nick is the short human name ("Speaker", "HDMI 1"); the description is the full chipset mouthful
    function deviceName(node) { return node?.nickname || node?.description || "No output"; }
    function pct(node) { return Math.round((node?.audio?.volume ?? 0) * 100) + "%"; }
    function deviceIcon(node) {
        const s = ((node?.description ?? "") + " " + (node?.name ?? "")).toLowerCase();
        return s.includes("hdmi") || s.includes("displayport") ? "monitor-speaker"
             : s.includes("headphone") || s.includes("headset") ? "headphones" : "speaker";
    }
    // apps playing through the pipewire alsa plugin only identify themselves as "PipeWire ALSA [binary]"; dig the binary out
    function appBinary(node) {
        const p = node.properties ?? {};
        const m = /^PipeWire ALSA \[(.+)\]$/.exec(p["application.name"] ?? "") ?? /^alsa_playback\.(.+)$/.exec(node.name ?? "");
        return m ? m[1] : (p["application.process.binary"] ?? "");
    }
    function appName(node) {
        const p = node.properties ?? {};
        const bin = appBinary(node);
        const raw = bin || p["application.name"] || node.nickname || node.description || node.name || "";
        return raw === raw.toLowerCase() ? raw.charAt(0).toUpperCase() + raw.slice(1) : raw;   // "plexamp" -> "Plexamp"
    }
    function mediaName(node) {
        const p = node.properties ?? {};
        const m = p["media.name"] ?? "";
        return m === "ALSA Playback" || m === "Playback" ? "" : m;   // generic alsa plugin titles carry no information
    }
    function appIcon(node) {
        const p = node.properties ?? {};
        return Quickshell.iconPath(p["application.icon-name"] || appBinary(node) || "", true);
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
                        radius: Theme.cardRadius
                        color: active ? Theme.highlightMed : devHover.containsMouse ? Theme.hover : "transparent"
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

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            // input: device name (click to pick another microphone), mute, percentage, slider
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Icon { name: popup.source?.audio?.muted ? "mic-off" : "mic"; size: 16; color: popup.source?.audio?.muted ? Theme.subtle : Theme.fg }
                Text {
                    Layout.fillWidth: true
                    text: popup.source ? popup.deviceName(popup.source) : "No input"
                    elide: Text.ElideRight
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                    MouseArea { anchors.fill: parent; enabled: popup.sources.length > 1; onClicked: popup.showInputs = !popup.showInputs }
                }
                Icon {
                    visible: popup.sources.length > 1
                    name: popup.showInputs ? "chevron-up" : "chevron-down"; size: 14; color: Theme.subtle
                    MouseArea { anchors.fill: parent; onClicked: popup.showInputs = !popup.showInputs }
                }
                Text {
                    text: popup.pct(popup.source)
                    color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                }
                MuteButton { node: popup.source; onIcon: "mic"; offIcon: "mic-off" }
            }
            VolumeSlider {
                Layout.fillWidth: true
                value: popup.source?.audio?.volume ?? 0
                active: !(popup.source?.audio?.muted ?? false)
                onMoved: v => { if (popup.source?.audio) popup.source.audio.volume = v; }
            }
            Text {
                visible: popup.captures.length > 0
                Layout.leftMargin: 24
                text: "In use by " + popup.captures.map(n => popup.appName(n)).filter((v, i, a) => a.indexOf(v) === i).join(", ")
                elide: Text.ElideRight
                Layout.fillWidth: true
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 2
            }

            // input picker, folded away unless there is a choice
            ColumnLayout {
                visible: popup.showInputs && popup.sources.length > 1
                Layout.fillWidth: true
                spacing: 2
                Repeater {
                    model: popup.sources
                    delegate: Rectangle {
                        id: srcRow
                        required property PwNode modelData
                        readonly property bool active: modelData === popup.source
                        Layout.fillWidth: true
                        implicitHeight: 28
                        radius: Theme.cardRadius
                        color: active ? Theme.highlightMed : srcHover.containsMouse ? Theme.hover : "transparent"
                        RowLayout {
                            anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                            spacing: 8
                            Icon { name: "mic"; size: 14; color: srcRow.active ? Theme.accent : Theme.subtle }
                            Text {
                                Layout.fillWidth: true
                                text: popup.deviceName(srcRow.modelData)
                                elide: Text.ElideRight
                                color: srcRow.active ? Theme.text : Theme.subtle
                                font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                            }
                            Icon { visible: srcRow.active; name: "check"; size: 14; color: Theme.accent }
                        }
                        MouseArea {
                            id: srcHover
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: { Pipewire.preferredDefaultAudioSource = srcRow.modelData; popup.showInputs = false; }
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

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
        property string onIcon: "volume-2"
        property string offIcon: "volume-x"
        readonly property bool muted: node?.audio?.muted ?? false
        implicitWidth: 20; implicitHeight: 20
        Icon {
            anchors.centerIn: parent
            name: parent.muted ? parent.offIcon : parent.onIcon
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
