import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs

// dropdown listing every available power profile; the active one is marked and clicking a row selects it
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
    implicitWidth: 180
    implicitHeight: card.implicitHeight

    readonly property var profiles: [
        { value: PowerProfile.PowerSaver,  label: "Power saver", icon: "leaf" },
        { value: PowerProfile.Balanced,    label: "Balanced",    icon: "gauge" },
        { value: PowerProfile.Performance, label: "Performance", icon: "zap" },
    ].filter(p => p.value !== PowerProfile.Performance || PowerProfiles.hasPerformanceProfile)

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.highlightHigh
        implicitHeight: col.implicitHeight + 16

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
            spacing: 2

            Repeater {
                model: popup.profiles
                delegate: Rectangle {
                    id: row
                    required property var modelData
                    readonly property bool active: PowerProfiles.profile === modelData.value
                    Layout.fillWidth: true
                    implicitHeight: 30
                    radius: Theme.cardRadius
                    color: active ? Theme.highlightMed : hover.containsMouse ? Theme.hover : "transparent"

                    RowLayout {
                        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                        spacing: 8
                        Icon {
                            name: row.modelData.icon
                            size: 14
                            color: row.active ? Theme.accent : Theme.subtle
                        }
                        Text {
                            Layout.fillWidth: true
                            text: row.modelData.label
                            color: row.active ? Theme.text : Theme.subtle
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                        }
                        Icon {
                            visible: row.active
                            name: "check"
                            size: 14
                            color: Theme.accent
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            PowerProfiles.profile = row.modelData.value;
                            popup.visible = false;
                        }
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; Layout.topMargin: 4; Layout.bottomMargin: 4; implicitHeight: 1; color: Theme.highlightMed }

            // night light: hyprsunset's blue light filter
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 10; Layout.rightMargin: 10
                spacing: 8
                Icon { name: "moon"; size: 14; color: NightLight.on ? Theme.accent : Theme.subtle }
                Text {
                    Layout.fillWidth: true
                    text: "Night light"
                    color: NightLight.on ? Theme.text : Theme.subtle
                    font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                }
                Toggle { on: NightLight.on; onToggled: NightLight.toggle() }
            }
        }
    }
}
