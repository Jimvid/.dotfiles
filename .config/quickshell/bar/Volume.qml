import Quickshell.Services.Pipewire
import QtQuick
import qs

// speaker icon plus a thin slider for the default output; click the icon for the mixer, right click mutes, scroll or drag changes the volume
Row {
    id: root
    readonly property PwNode sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: [root.sink] }

    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    function setVolume(v) { if (sink?.audio) sink.audio.volume = Math.max(0, Math.min(1, v)); }
    function toggleMute() { if (sink?.audio) sink.audio.muted = !muted; }

    Glyph {
        id: glyph
        icon: root.muted ? "volume-x" : root.vol < 0.34 ? "volume" : root.vol < 0.67 ? "volume-1" : "volume-2"
        color: root.muted ? Theme.subtle : Theme.fg
        tip: (root.muted ? "Muted" : Math.round(root.vol * 100) + "%") + (root.sink ? "\n" + root.sink.description : "")
        onClicked: mouse => { if (mouse.button === Qt.RightButton) root.toggleMute(); else popup.visible = !popup.visible; }
        onScrolled: delta => root.setVolume(root.vol + (delta > 0 ? 0.05 : -0.05))
    }

    // the slider: a thin track that fills with the accent; the hit area is the full bar height so it is easy to grab
    Item {
        id: slider
        width: 56 + Theme.pillPadding
        height: Theme.barHeight

        Rectangle {
            id: track
            anchors.verticalCenter: parent.verticalCenter
            x: 0
            width: 56; height: 4; radius: 2
            color: Theme.highlightMed

            Rectangle {
                width: Math.max(4, parent.width * Math.max(0, Math.min(1, root.vol)))
                height: parent.height; radius: 2
                color: root.muted ? Theme.subtle : Theme.accent
                opacity: area.containsMouse || area.pressed ? 1 : 0.85
                Behavior on width { NumberAnimation { duration: 40 } }
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: mouse => { if (mouse.button === Qt.RightButton) root.toggleMute(); else root.setVolume(mouse.x / track.width); }
            onPositionChanged: mouse => { if (pressed && (mouse.buttons & Qt.LeftButton)) root.setVolume(mouse.x / track.width); }
            onWheel: wheel => root.setVolume(root.vol + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
        }
    }

    VolumePopup { id: popup; target: glyph }
}
