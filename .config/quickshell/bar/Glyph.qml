import QtQuick
import qs

// one bar module: optional text label and/or lucide icon, padding, hover tooltip, click/scroll signals
Item {
    id: root
    property string text: ""
    property string icon: ""
    property color color: Theme.fg
    property string tip: ""
    property int padding: Theme.pillPadding
    property int iconSize: 16
    property bool mono: true      // nerd-font glyphs need the mono font; numbers read better in it too
    signal clicked(var mouse)
    signal scrolled(int delta)

    // every module lights up in the accent while hovered, like the tray icons
    readonly property color shown: area.containsMouse ? Theme.accent : color

    implicitWidth: row.implicitWidth + 2 * padding
    implicitHeight: Theme.barHeight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Text {
            visible: root.text !== ""
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            font.family: root.mono ? Theme.mono : Theme.ui
            font.pixelSize: Theme.fontSize
            color: root.shown
        }
        Icon {
            visible: root.icon !== ""
            anchors.verticalCenter: parent.verticalCenter
            name: root.icon
            size: root.iconSize
            color: root.shown
        }
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
