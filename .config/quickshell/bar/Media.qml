import Quickshell.Services.Mpris
import QtQuick
import qs

// now playing: the level meter while a track plays (a play icon when paused) and the track; click for the player popup,
// right click toggles playback, scroll skips
Item {
    id: root
    readonly property MprisPlayer player: Players.active
    visible: player !== null
    implicitWidth: row.implicitWidth + 2 * Theme.pillPadding
    implicitHeight: Theme.barHeight

    readonly property bool playing: player?.isPlaying ?? false
    readonly property string label: Players.artist(player) ? Players.artist(player) + " – " + Players.title(player) : Players.title(player)

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8

        Waves {
            visible: root.playing
            running: root.visible && root.playing
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.accent
        }
        Icon {
            visible: !root.playing
            anchors.verticalCenter: parent.verticalCenter
            name: "play"; size: Theme.barIconSize - 2; color: Theme.subtle   // the triangle fills its box more than other glyphs, so it sits 2px smaller to look the same size
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label.length > 36 ? root.label.slice(0, 35) + "…" : root.label
            color: root.playing ? Theme.fg : Theme.subtle
            font.family: Theme.ui; font.pixelSize: Theme.fontSize
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.AllButtons
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) { if (root.player?.canTogglePlaying) root.player.togglePlaying(); }
            else popup.visible = !popup.visible;
        }
        onWheel: wheel => {
            if (!root.player) return;
            if (wheel.angleDelta.y < 0 && root.player.canGoNext) root.player.next();
            else if (wheel.angleDelta.y > 0 && root.player.canGoPrevious) root.player.previous();
        }
    }

    Tooltip {
        target: root
        text: root.player ? root.player.identity + "\n" + root.label : ""
        shown: text !== "" && area.containsMouse
    }
    MediaPopup { id: popup; target: root }
}
