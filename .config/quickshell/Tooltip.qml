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
    anchor.margins.top: 6

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
        border.color: Theme.overlay

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
