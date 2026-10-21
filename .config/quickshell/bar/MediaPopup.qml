import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import qs

// the player: cover, track, progress and transport; a row of players to pick from when more than one is open
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

    property MprisPlayer chosen: null
    readonly property MprisPlayer player: chosen && Players.all.includes(chosen) ? chosen : Players.active
    readonly property real progress: player && player.lengthSupported && player.length > 0 ? player.position / player.length : 0

    // mpris only pushes the position on seeks; ask for it while the popup is open
    Timer { interval: 1000; repeat: true; running: popup.visible && (popup.player?.isPlaying ?? false); onTriggered: popup.player.positionChanged() }

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.cardRadius
        color: Theme.surface
        implicitHeight: col.implicitHeight + 24

        border.width: 1
        border.color: Theme.highlightHigh

        readonly property bool hasArt: cover.status === Image.Ready

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
            spacing: 10

            // player picker
            RowLayout {
                visible: Players.all.length > 1
                Layout.fillWidth: true
                spacing: 4
                Repeater {
                    model: Players.all
                    delegate: Rectangle {
                        id: chip
                        required property MprisPlayer modelData
                        readonly property bool selected: modelData === popup.player
                        implicitWidth: chipLabel.implicitWidth + 16
                        implicitHeight: 22
                        radius: Theme.fieldRadius
                        color: selected ? Theme.highlightMed : chipHover.containsMouse ? Theme.hover : "transparent"
                        Text {
                            id: chipLabel
                            anchors.centerIn: parent
                            text: chip.modelData.identity
                            color: chip.selected ? Theme.text : Theme.subtle
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 1
                        }
                        MouseArea { id: chipHover; anchors.fill: parent; hoverEnabled: true; onClicked: popup.chosen = chip.modelData }
                    }
                }
            }

            // cover and track
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                Rectangle {
                    Layout.preferredWidth: 64; Layout.preferredHeight: 64
                    radius: Theme.fieldRadius
                    color: Theme.highlightLow
                    border.width: 1
                    border.color: Qt.alpha(Theme.highlightHigh, 0.6)
                    clip: true
                    Image {
                        id: cover
                        anchors.fill: parent
                        source: popup.player?.trackArtUrl ?? ""
                        sourceSize: Qt.size(128, 128)
                        fillMode: Image.PreserveAspectCrop
                        visible: status === Image.Ready
                    }
                    Icon { anchors.centerIn: parent; visible: !card.hasArt; name: "music"; size: 22; color: Theme.subtle }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        Layout.fillWidth: true
                        text: Players.title(popup.player)
                        elide: Text.ElideRight
                        color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                    }
                    Text {
                        Layout.fillWidth: true
                        visible: text !== ""
                        text: Players.artist(popup.player)
                        elide: Text.ElideRight
                        color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                    Text {
                        Layout.fillWidth: true
                        visible: text !== ""
                        text: popup.player?.trackAlbum ?? ""
                        elide: Text.ElideRight
                        color: Theme.muted; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 2
                    }
                }
            }

            // progress
            ColumnLayout {
                Layout.fillWidth: true
                visible: popup.player?.lengthSupported ?? false
                spacing: 4
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 4
                    radius: 2
                    color: Theme.highlightMed
                    Rectangle {
                        width: parent.width * Math.max(0, Math.min(1, popup.progress))
                        height: parent.height; radius: 2
                        color: Theme.accent
                    }
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        enabled: popup.player?.canSeek ?? false
                        onClicked: mouse => popup.player.position = popup.player.length * Math.max(0, Math.min(1, (mouse.x - 6) / width))
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: Players.fmt(popup.player?.position ?? 0); color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 2 }
                    Item { Layout.fillWidth: true }
                    Text { text: Players.fmt(popup.player?.length ?? 0); color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 2 }
                }
            }

            // transport
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 18
                Control { name: "skip-back"; size: 18; enabled: popup.player?.canGoPrevious ?? false; onClicked: popup.player.previous() }
                Rectangle {
                    implicitWidth: 36; implicitHeight: 36; radius: 18
                    color: playHover.containsMouse ? Qt.lighter(Theme.accent, 1.1) : Theme.accent
                    opacity: popup.player?.canTogglePlaying ? 1 : 0.5
                    Icon { anchors.centerIn: parent; name: popup.player?.isPlaying ? "pause" : "play"; size: 16; color: Theme.base }
                    MouseArea { id: playHover; anchors.fill: parent; hoverEnabled: true; enabled: popup.player?.canTogglePlaying ?? false; onClicked: popup.player.togglePlaying() }
                }
                Control { name: "skip-forward"; size: 18; enabled: popup.player?.canGoNext ?? false; onClicked: popup.player.next() }
            }
        }
    }

    component Control: Item {
        property string name
        property int size: 16
        property bool enabled: true
        signal clicked()
        implicitWidth: size + 8; implicitHeight: size + 8
        opacity: enabled ? 1 : 0.4
        Icon { anchors.centerIn: parent; name: parent.name; size: parent.size; color: ctlHover.containsMouse && parent.enabled ? Theme.text : Theme.subtle }
        MouseArea { id: ctlHover; anchors.fill: parent; hoverEnabled: true; enabled: parent.enabled; onClicked: parent.clicked() }
    }
}
