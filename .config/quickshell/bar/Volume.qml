import Quickshell.Services.Pipewire
import QtQuick
import qs

Row {
    id: root
    readonly property PwNode sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: [root.sink] }

    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    function setVolume(v) { if (sink?.audio) sink.audio.volume = Math.max(0, Math.min(1, v)); }

    Glyph {
        text: root.muted ? "\ueee8" : root.vol < 0.34 ? "\uf026" : root.vol < 0.67 ? "\uf027" : "\uf028"
        color: root.muted ? Theme.subtle : Theme.accent
        tip: Math.round(root.vol * 100) + "%"
        onClicked: if (root.sink?.audio) root.sink.audio.muted = !root.muted
        onScrolled: delta => root.setVolume(root.vol + (delta > 0 ? 0.05 : -0.05))
    }

    // inline slider, same as waybar's pulseaudio/slider
    Item {
        width: 40 + Theme.pillPadding
        height: Theme.barHeight

        Rectangle {
            id: trough
            anchors.verticalCenter: parent.verticalCenter
            x: 0; width: 40; height: 4; radius: 2
            color: Theme.overlay

            Rectangle {
                width: Math.max(4, parent.width * root.vol)
                height: parent.height; radius: 2
                color: root.muted ? Theme.subtle : Theme.accent
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: mouse => root.setVolume(mouse.x / trough.width)
            onPositionChanged: mouse => { if (pressed) root.setVolume(mouse.x / trough.width); }
            onWheel: wheel => root.setVolume(root.vol + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
        }
    }
}
