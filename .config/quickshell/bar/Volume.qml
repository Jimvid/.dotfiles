import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import qs

// speaker icon plus a five-band level meter that moves with whatever is playing; click for the mixer
Row {
    id: root
    readonly property PwNode sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: [root.sink] }

    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    // an app has a playback stream open (quickshell flags playback streams as sinks); browsers keep one open while paused, which just meters silence
    readonly property bool playing: Pipewire.nodes.values.some(n => n.isStream && n.isSink && n.audio !== null)
    property var levels: [0, 0, 0, 0, 0]

    function setVolume(v) { if (sink?.audio) sink.audio.volume = Math.max(0, Math.min(1, v)); }
    function toggleMute() { if (sink?.audio) sink.audio.muted = !muted; }

    // records the default sink's monitor at 8 kHz mono and prints five band levels 20x a second
    Process {
        id: meter
        running: root.playing && !root.muted
        // the trap tears the whole pipeline down when quickshell stops the shell, otherwise pw-cat and awk outlive it
        command: ["sh", "-c",
            "trap 'kill %1 2>/dev/null; exit 0' TERM INT; "
            + "pw-cat --record --raw --format=s16 --rate=8000 --channels=1 -P '{stream.capture.sink=true}' - "
            + "| od -An -v -td2 -w2 | awk -f \"$0\" & wait",
            Qt.resolvedUrl("meter.awk").toString().replace("file://", "")]
        stdout: SplitParser {
            onRead: line => {
                const p = line.trim().split(/\s+/).map(Number);
                if (p.length === 5 && !p.some(isNaN)) root.levels = p;
            }
        }
        onRunningChanged: if (!running) root.levels = [0, 0, 0, 0, 0]
    }

    Glyph {
        icon: root.muted ? "volume-x" : root.vol < 0.34 ? "volume" : root.vol < 0.67 ? "volume-1" : "volume-2"
        color: root.muted ? Theme.subtle : Theme.fg
        tip: (root.muted ? "Muted" : Math.round(root.vol * 100) + "%") + (root.sink ? "\n" + (root.sink.nickname || root.sink.description) : "")
        onClicked: mouse => { if (mouse.button === Qt.RightButton) root.toggleMute(); else popup.visible = !popup.visible; }
        onScrolled: delta => root.setVolume(root.vol + (delta > 0 ? 0.05 : -0.05))
    }

    // the meter: five bars, idle as dots, dancing with the bands while something plays
    Item {
        id: bars
        width: barsRow.implicitWidth + Theme.pillPadding
        height: Theme.barHeight

        Row {
            id: barsRow
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            Repeater {
                model: 5
                delegate: Rectangle {
                    required property int index
                    readonly property real level: Math.min(1, Math.pow(root.levels[index] * 3, 0.6))
                    anchors.verticalCenter: parent.verticalCenter
                    width: 3
                    height: 3 + level * 13
                    radius: 1.5
                    color: root.muted ? Theme.subtle : Theme.fg
                    opacity: 0.55 + 0.45 * level
                    Behavior on height { NumberAnimation { duration: 70 } }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onClicked: mouse => { if (mouse.button === Qt.RightButton) root.toggleMute(); else popup.visible = !popup.visible; }
            onWheel: wheel => root.setVolume(root.vol + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
        }
    }

    VolumePopup { id: popup; target: root }
}
