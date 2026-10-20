import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

// caffeine: on/off and how long to stay awake
PopupWindow {
    id: popup
    required property Item target
    visible: false
    grabFocus: true

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away

    color: "transparent"
    implicitWidth: 220
    implicitHeight: card.implicitHeight

    onVisibleChanged: if (visible) Caffeine.now = Date.now()

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.highlightHigh
        implicitHeight: col.implicitHeight + 24

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Icon { name: "coffee"; size: 16; color: Caffeine.active ? Theme.accent : Theme.subtle }
                Text {
                    Layout.fillWidth: true
                    text: "Caffeine"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Text {
                    visible: Caffeine.active
                    text: Caffeine.remaining
                    color: Theme.subtle; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 1
                }
                Toggle { on: Caffeine.active; onToggled: Caffeine.toggle() }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            Repeater {
                model: Caffeine.options
                delegate: Rectangle {
                    id: row
                    required property var modelData
                    readonly property bool selected: Caffeine.active && Caffeine.minutes === modelData.minutes
                    Layout.fillWidth: true
                    implicitHeight: 28
                    radius: Theme.fieldRadius
                    color: selected ? Theme.highlightMed : hover.containsMouse ? Theme.highlightLow : "transparent"
                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        Text {
                            Layout.fillWidth: true
                            text: row.modelData.label
                            color: row.selected ? Theme.text : Theme.subtle
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                        }
                        Icon { visible: row.selected; name: "check"; size: 14; color: Theme.accent }
                    }
                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: { Caffeine.start(row.modelData.minutes); popup.visible = false; }
                    }
                }
            }
        }
    }
}
