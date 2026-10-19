import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs

Row {
    spacing: 4
    leftPadding: Theme.pillPadding
    rightPadding: Theme.pillPadding
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items
        delegate: Item {
            id: entry
            required property SystemTrayItem modelData
            implicitWidth: 20
            implicitHeight: Theme.barHeight

            IconImage {
                anchors.centerIn: parent
                implicitSize: 16
                source: entry.modelData.icon
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton && entry.modelData.hasMenu) menu.open();
                    else if (mouse.button === Qt.MiddleButton) entry.modelData.secondaryActivate();
                    else if (entry.modelData.onlyMenu && entry.modelData.hasMenu) menu.open();
                    else entry.modelData.activate();
                }
                onWheel: wheel => entry.modelData.scroll(wheel.angleDelta.y / 120, false)
            }

            QsMenuAnchor {
                id: menu
                menu: entry.modelData.menu
                anchor.item: entry
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.margins.top: 6
            }

            Tooltip {
                target: entry
                text: entry.modelData.tooltipTitle || entry.modelData.title
                shown: text !== "" && area.containsMouse
            }
        }
    }
}
