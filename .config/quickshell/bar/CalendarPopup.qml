import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs

PopupWindow {
    id: popup
    required property Item target
    visible: false

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 6

    color: "transparent"
    implicitWidth: card.implicitWidth
    implicitHeight: card.implicitHeight

    property date shown: new Date()
    onVisibleChanged: if (visible) shown = new Date()

    Rectangle {
        id: card
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.overlay
        implicitWidth: col.implicitWidth + 24
        implicitHeight: col.implicitHeight + 24

        ColumnLayout {
            id: col
            anchors.centerIn: parent
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "❮"; color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    MouseArea { anchors.fill: parent; onClicked: popup.shown = new Date(popup.shown.getFullYear(), popup.shown.getMonth() - 1, 1) }
                }
                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(popup.shown, "MMMM yyyy")
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Text {
                    text: "❯"; color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    MouseArea { anchors.fill: parent; onClicked: popup.shown = new Date(popup.shown.getFullYear(), popup.shown.getMonth() + 1, 1) }
                }
            }

            DayOfWeekRow {
                Layout.fillWidth: true
                locale: Qt.locale("en_GB")
                delegate: Text {
                    required property var model
                    text: model.shortName; horizontalAlignment: Text.AlignHCenter
                    color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                }
            }

            MonthGrid {
                id: grid
                Layout.fillWidth: true
                locale: Qt.locale("en_GB")
                month: popup.shown.getMonth()
                year: popup.shown.getFullYear()
                delegate: Text {
                    required property var model
                    readonly property bool today: model.today
                    text: model.day
                    horizontalAlignment: Text.AlignHCenter
                    opacity: model.month === grid.month ? 1 : 0.35
                    color: today ? Theme.iris : Theme.text
                    font.family: Theme.ui
                    font.pixelSize: Theme.uiFontSize
                    font.bold: today
                    font.underline: today
                }
            }
        }
    }
}
