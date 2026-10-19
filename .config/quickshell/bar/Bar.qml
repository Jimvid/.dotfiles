import Quickshell
import QtQuick
import qs

PanelWindow {
    id: bar
    property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight + 2 * Theme.barMargin
    color: "transparent"

    Pill {
        anchors.left: parent.left
        anchors.leftMargin: Theme.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        Logo {}
        Clock {}
    }

    Pill {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        sidePadding: Theme.pillPadding
        Workspaces { screen: bar.screen }
    }

    Pill {
        anchors.right: parent.right
        anchors.rightMargin: Theme.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        Tray {}
        Volume {}
        PowerProfile {}
        Bluetooth {}
        Network {}
        Battery {}
        Bell {}
    }
}
