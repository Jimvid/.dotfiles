import QtQuick
import qs

// one bar module: a mono/nerd-font label with padding, hover tooltip and click/scroll signals
Item {
    id: root
    property alias text: label.text
    property alias color: label.color
    property string tip: ""
    property int padding: Theme.pillPadding
    signal clicked(var mouse)
    signal scrolled(int delta)

    implicitWidth: label.implicitWidth + 2 * padding
    implicitHeight: Theme.barHeight

    Text {
        id: label
        anchors.centerIn: parent
        font.family: Theme.mono
        font.pixelSize: Theme.fontSize
        color: Theme.accent
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.AllButtons
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => root.scrolled(wheel.angleDelta.y)
    }

    Tooltip {
        target: root
        text: root.tip
        shown: root.tip !== "" && area.containsMouse
    }
}
