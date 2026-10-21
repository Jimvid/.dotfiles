import Quickshell
import QtQuick
import qs

PanelWindow {
    id: bar
    property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: Theme.barHeight + Theme.barMargin   // margin above only: hyprland adds gaps_out below the bar, which gives the same gap to the windows
    color: "transparent"

    Pill {
        anchors.left: parent.left
        anchors.leftMargin: Theme.sideMargin
        anchors.bottom: parent.bottom
        sidePadding: Theme.pillInset
        Clock {}
        Media {}
    }

    Pill {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        sidePadding: Theme.pillInset
        Workspaces { screen: bar.screen }
    }

    Pill {
        anchors.right: parent.right
        anchors.rightMargin: Theme.sideMargin
        anchors.bottom: parent.bottom
        sidePadding: Theme.pillInset
        Tray {}
        Volume {}
        MicStatus {}
        Brightness {}
        CaffeineBar {}
        PowerProfile {}
        Bluetooth {}
        Network {}
        Vpn {}
        Battery {}
        Bell {}
    }
}
