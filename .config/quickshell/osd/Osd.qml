import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import qs

// on-screen display for the media keys: a small card at the bottom of the focused screen with an icon, a level bar and the value.
// the hyprland binds call `qs ipc call osd volume|mic|brightness` after changing the level
Scope {
    id: root
    property string kind: ""        // volume, mic, brightness
    property bool shown: false

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    PwObjectTracker { objects: [root.sink, root.source] }

    readonly property real level: kind === "volume" ? (sink?.audio?.volume ?? 0)
                                : kind === "mic"    ? (source?.audio?.volume ?? 0)
                                : Backlight.percent / 100
    readonly property bool muted: kind === "volume" ? (sink?.audio?.muted ?? false)
                                : kind === "mic"    ? (source?.audio?.muted ?? false)
                                : false
    readonly property string icon: kind === "brightness" ? "sun"
                                 : kind === "mic" ? (muted ? "mic-off" : "mic")
                                 : muted ? "volume-x" : level < 0.34 ? "volume" : level < 0.67 ? "volume-1" : "volume-2"

    function show(k) { kind = k; shown = true; hide.restart(); }
    Timer { id: hide; interval: 1200; onTriggered: root.shown = false }

    IpcHandler {
        target: "osd"
        function volume(): void { root.show("volume"); }
        function mic(): void { root.show("mic"); }
        function brightness(): void { Backlight.refresh(); root.show("brightness"); }
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: win
            required property var modelData
            screen: modelData
            readonly property bool focused: (Hyprland.focusedMonitor?.name ?? Quickshell.screens[0]?.name) === modelData.name   // modelData, not screen: the window's screen gets reassigned while a monitor goes away
            visible: root.shown && focused

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-osd"
            exclusionMode: ExclusionMode.Ignore
            anchors.bottom: true
            margins.bottom: 48
            implicitWidth: 280
            implicitHeight: 48
            color: "transparent"
            mask: Region {}   // never takes input

            Rectangle {
                anchors.fill: parent
                radius: Theme.cardRadius
                color: Theme.surface
                border.width: 1
                border.color: Theme.highlightHigh

                RowLayout {
                    anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                    spacing: 12
                    Icon { name: root.icon; size: 18; color: root.muted ? Theme.subtle : Theme.fg }
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 4
                        radius: 2
                        color: Theme.highlightMed
                        Rectangle {
                            width: parent.width * Math.max(0, Math.min(1, root.level))
                            height: parent.height; radius: 2
                            color: root.muted ? Theme.subtle : Theme.accent
                            Behavior on width { NumberAnimation { duration: 80 } }
                        }
                    }
                    Text {
                        Layout.preferredWidth: 38
                        horizontalAlignment: Text.AlignRight
                        text: root.muted ? "off" : Math.round(root.level * 100) + "%"
                        color: root.muted ? Theme.subtle : Theme.text
                        font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                    }
                }
            }
        }
    }
}
