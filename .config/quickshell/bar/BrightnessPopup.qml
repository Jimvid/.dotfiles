import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

// brightness: the level and a slider, in the mixer's style
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
    implicitWidth: 260
    implicitHeight: card.implicitHeight

    onVisibleChanged: if (visible) Backlight.refresh()

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
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Icon { name: "sun"; size: 16; color: Theme.fg }
                Text {
                    Layout.fillWidth: true
                    text: "Brightness"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Text {
                    text: Backlight.percent + "%"
                    color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize
                }
            }
            VolumeSlider {
                Layout.fillWidth: true
                value: Backlight.percent / 100
                onMoved: v => Backlight.set(v * 100)
            }
        }
    }
}
