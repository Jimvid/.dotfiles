import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import qs

// tray icons styled like the rest of the bar: known apps get a lucide icon, anything else is tinted monochrome
Row {
    id: tray
    spacing: Theme.spacing   // each entry already carries glyph padding, so tray icons sit on the same rhythm as the modules

    // tray item id (substring, case-insensitive) -> lucide icon in icons/
    readonly property var overrides: ({ "1password": "key-round" })
    function lucideFor(item) {
        const id = (item.id + " " + item.title).toLowerCase();
        for (const key in overrides) if (id.includes(key)) return overrides[key];
        return "";
    }
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items
        delegate: Item {
            id: entry
            required property SystemTrayItem modelData
            implicitWidth: 16 + 2 * Theme.pillPadding
            implicitHeight: Theme.barHeight

            readonly property string lucide: tray.lucideFor(modelData)
            readonly property color tint: area.containsMouse ? Theme.accent : Theme.fg

            Icon {
                visible: entry.lucide !== ""
                anchors.centerIn: parent
                name: entry.lucide
                size: 16
                color: entry.tint
            }

            // unknown app: desaturate the app's own icon and tint it to the bar colour
            IconImage {
                id: raw
                visible: false
                anchors.centerIn: parent
                implicitSize: 16
                source: entry.modelData.icon
            }
            MultiEffect {
                visible: entry.lucide === ""
                source: raw
                anchors.fill: raw
                saturation: -1
                colorization: 1.0
                colorizationColor: entry.tint
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
                anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away
            }

            Tooltip {
                target: entry
                text: entry.modelData.tooltipTitle || entry.modelData.title
                shown: text !== "" && area.containsMouse
            }
        }
    }
}
