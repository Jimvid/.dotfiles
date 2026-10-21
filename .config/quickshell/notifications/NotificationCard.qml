import QtQuick
import QtQuick.Layouts
import qs

// one notification: app icon, app name, summary, body and action buttons; as a card on screen or a flat row in the history
Rectangle {
    id: card
    property string appName: ""
    property string summary: ""
    property string body: ""
    property int urgency: 1          // NotificationUrgency: 0 low, 1 normal, 2 critical
    property string icon: ""         // Image source, "" for none
    property string age: ""          // top right, history only
    property var actions: []         // NotificationAction objects, popups only
    property bool flat: false        // history row: no border, hover highlight
    property alias hovered: hover.containsMouse
    signal closeClicked()
    signal clicked()

    readonly property var buttons: actions.filter(a => a.identifier !== "default")

    radius: Theme.cardRadius
    color: flat ? (hover.containsMouse ? Theme.hover : "transparent") : Theme.surface
    border.width: flat ? 0 : 1
    border.color: urgency === 2 ? Theme.love : Theme.highlightHigh
    implicitHeight: content.implicitHeight + 2 * content.anchors.margins

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: card.clicked()
    }

    RowLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
        spacing: 10

        Image {
            visible: card.icon !== ""
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 28; Layout.preferredHeight: 28
            source: card.icon
            sourceSize: Qt.size(56, 56)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                Text {
                    Layout.fillWidth: true
                    text: card.appName
                    elide: Text.ElideRight
                    color: card.urgency === 2 ? Theme.love : Theme.subtle
                    font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 2
                }
                Text {
                    visible: card.age !== ""
                    text: card.age
                    color: Theme.muted
                    font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 2
                }
                Item {
                    implicitWidth: 16; implicitHeight: 16
                    Icon { anchors.centerIn: parent; name: "x"; size: 14; color: closeHover.containsMouse ? Theme.text : Theme.subtle }
                    MouseArea { id: closeHover; anchors.fill: parent; hoverEnabled: true; onClicked: card.closeClicked() }
                }
            }
            Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: card.summary
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                color: Theme.text
                font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: true
            }
            Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: card.body
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                maximumLineCount: 6
                elide: Text.ElideRight
                color: Theme.subtle
                linkColor: Theme.accent
                font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                onLinkActivated: link => Qt.openUrlExternally(link)
            }
            RowLayout {
                visible: card.buttons.length > 0
                Layout.topMargin: 6
                spacing: 6
                Repeater {
                    model: card.buttons
                    delegate: Rectangle {
                        id: btn
                        required property var modelData
                        implicitWidth: label.implicitWidth + 20
                        implicitHeight: 24
                        radius: Theme.fieldRadius
                        color: btnHover.containsMouse ? Theme.highlightHigh : Theme.highlightMed
                        Text {
                            id: label
                            anchors.centerIn: parent
                            text: btn.modelData.text
                            color: Theme.text
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 1
                        }
                        MouseArea { id: btnHover; anchors.fill: parent; hoverEnabled: true; onClicked: btn.modelData.invoke() }
                    }
                }
            }
        }
    }
}
