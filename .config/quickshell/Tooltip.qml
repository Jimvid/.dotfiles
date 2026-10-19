import Quickshell
import QtQuick
import qs

// small popup below a bar item, shown after a short hover delay
PopupWindow {
    id: tip
    required property Item target
    property string text: ""
    property bool shown: false
    visible: false

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away

    color: "transparent"
    implicitWidth: body.implicitWidth + 20
    implicitHeight: body.implicitHeight + 12

    onShownChanged: shown ? delay.restart() : (delay.stop(), visible = false)
    Timer { id: delay; interval: 500; onTriggered: tip.visible = true }

    Rectangle {
        anchors.fill: parent
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.highlightHigh

        Text {
            id: body
            anchors.centerIn: parent
            text: tip.text
            textFormat: Text.PlainText
            font.family: Theme.ui
            font.pixelSize: Theme.uiFontSize
            color: Theme.text
        }
    }
}
