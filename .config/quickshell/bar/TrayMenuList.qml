import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

// the entries of one dbus menu level; a submenu unfolds inline, indented, below its parent entry
ColumnLayout {
    id: list
    property var handle          // QsMenuHandle: the tray item's menu or a submenu entry
    property int depth: 0
    signal activated()           // an entry was triggered, the popup can close

    readonly property int count: opener.children.values.length

    spacing: 1
    QsMenuOpener { id: opener; menu: list.handle }

    Repeater {
        model: opener.children
        delegate: ColumnLayout {
            id: row
            required property var modelData
            property bool expanded: false
            readonly property bool checked: modelData.checkState === Qt.Checked
            readonly property bool checkable: modelData.buttonType !== QsMenuButtonType.None
            Layout.fillWidth: true
            spacing: 1

            // separator
            Rectangle {
                visible: row.modelData.isSeparator
                Layout.fillWidth: true
                Layout.topMargin: 3; Layout.bottomMargin: 3
                implicitHeight: 1
                color: Theme.highlightMed
            }

            // entry
            Rectangle {
                visible: !row.modelData.isSeparator
                Layout.fillWidth: true
                implicitHeight: 28
                radius: Theme.fieldRadius
                color: hover.containsMouse && row.modelData.enabled ? Theme.highlightLow : "transparent"

                RowLayout {
                    anchors { fill: parent; leftMargin: 8 + list.depth * 12; rightMargin: 8 }
                    spacing: 8

                    // check / radio state, kept as a fixed slot so labels line up
                    Item {
                        visible: row.checkable
                        implicitWidth: 14; implicitHeight: 14
                        Icon { anchors.centerIn: parent; visible: row.checked; name: "check"; size: 14; color: Theme.accent }
                    }
                    Image {
                        visible: row.modelData.icon !== "" && !row.checkable
                        Layout.preferredWidth: 14; Layout.preferredHeight: 14
                        source: row.modelData.icon
                        sourceSize: Qt.size(28, 28)
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        opacity: row.modelData.enabled ? 1 : 0.4
                    }
                    Text {
                        Layout.fillWidth: true
                        text: row.modelData.text
                        elide: Text.ElideRight
                        color: !row.modelData.enabled ? Theme.muted : row.checked ? Theme.text : Theme.subtle
                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                    Icon {
                        visible: row.modelData.hasChildren
                        name: row.expanded ? "chevron-down" : "chevron-right"; size: 14; color: Theme.subtle
                    }
                }

                MouseArea {
                    id: hover
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: row.modelData.enabled
                    onClicked: {
                        if (row.modelData.hasChildren) row.expanded = !row.expanded;
                        else { row.modelData.triggered(); list.activated(); }
                    }
                }
            }

            // submenu
            Loader {
                Layout.fillWidth: true
                active: row.expanded && row.modelData.hasChildren
                visible: active
                source: "TrayMenuList.qml"
                onLoaded: {
                    item.handle = row.modelData;
                    item.depth = list.depth + 1;
                    item.activated.connect(list.activated);
                }
            }
        }
    }
}
