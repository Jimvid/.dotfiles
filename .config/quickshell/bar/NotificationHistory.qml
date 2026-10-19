import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.notifications

// dropdown with everything received, newest first, plus do-not-disturb and clear
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
    implicitWidth: 360
    implicitHeight: card.implicitHeight

    onVisibleChanged: if (visible) { Notifs.unread = 0; now = Date.now(); }

    property real now: Date.now()
    Timer { interval: 30000; repeat: true; running: popup.visible; onTriggered: popup.now = Date.now() }
    function age(t) {
        const s = Math.max(0, (now - t) / 1000);
        return s < 60 ? "now" : s < 3600 ? Math.floor(s / 60) + "m" : s < 86400 ? Math.floor(s / 3600) + "h" : Math.floor(s / 86400) + "d";
    }

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
                Text {
                    Layout.fillWidth: true
                    text: "Notifications"
                    color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
                }
                Text {
                    visible: Notifs.history.length > 0
                    text: "Clear"
                    color: clearHover.containsMouse ? Theme.text : Theme.subtle
                    font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    MouseArea { id: clearHover; anchors.fill: parent; hoverEnabled: true; onClicked: Notifs.clearHistory() }
                }
                Text {
                    text: "Do not disturb"
                    color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    Layout.leftMargin: 8
                }
                Toggle { on: Notifs.dnd; onToggled: Notifs.dnd = !Notifs.dnd }
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.highlightMed }

            Flickable {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(list.implicitHeight, 520)
                contentHeight: list.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: list
                    width: parent.width
                    spacing: 2
                    Repeater {
                        model: Notifs.history
                        delegate: NotificationCard {
                            required property var modelData
                            Layout.fillWidth: true
                            flat: true
                            appName: modelData.appName
                            summary: modelData.summary
                            body: modelData.body
                            urgency: modelData.urgency
                            icon: modelData.icon
                            age: popup.age(modelData.time)
                            onCloseClicked: Notifs.forget(modelData.id)
                        }
                    }
                }
            }

            Text {
                visible: Notifs.history.length === 0
                text: "No notifications"
                color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
            }
        }
    }
}
