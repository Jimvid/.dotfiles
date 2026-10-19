import QtQuick
import qs

// minimal switch in theme colours
Rectangle {
    id: root
    property bool on: false
    signal toggled()
    implicitWidth: 34
    implicitHeight: 18
    radius: height / 2
    color: on ? Theme.accent : Theme.highlightMed

    Rectangle {
        width: 14; height: 14; radius: 7
        anchors.verticalCenter: parent.verticalCenter
        x: root.on ? parent.width - width - 2 : 2
        color: Theme.base
        Behavior on x { NumberAnimation { duration: 120 } }
    }
    MouseArea { anchors.fill: parent; onClicked: root.toggled() }
}
