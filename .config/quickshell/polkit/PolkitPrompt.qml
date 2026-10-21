import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Polkit
import QtQuick
import QtQuick.Layouts
import qs

// polkit agent: when something asks for authentication, every screen dims (hyprland blurs behind the qs-polkit layer)
// and the focused one shows a card in the popup style with the password field
Scope {
    id: root
    PolkitAgent { id: agent }
    readonly property AuthFlow flow: agent.flow
    readonly property bool active: flow !== null && !flow.isCompleted && !flow.isCancelled
    readonly property bool waiting: active && !flow.isResponseRequired   // password sent, pam is thinking

    function submit(input) {
        if (!flow || !flow.isResponseRequired) return;
        flow.submit(input.text);
        input.text = "";
    }
    function status() {
        if (!flow) return "";
        if (flow.supplementaryMessage !== "") return flow.supplementaryMessage;
        if (waiting) return "Authenticating…";
        if (flow.failed) return "Authentication failed, try again";
        return "";
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: win
            required property var modelData
            screen: modelData
            readonly property bool focused: (Hyprland.focusedMonitor?.name ?? Quickshell.screens[0]?.name) === modelData.name   // modelData, not screen: the window's screen gets reassigned while a monitor goes away
            visible: root.active

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-polkit"
            WlrLayershell.keyboardFocus: focused && visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Ignore
            anchors { top: true; bottom: true; left: true; right: true }
            color: "transparent"

            Rectangle { anchors.fill: parent; color: Theme.base; opacity: 0.55 }
            MouseArea { anchors.fill: parent }   // nothing underneath is clickable while the prompt is up

            onVisibleChanged: if (visible && focused) input.forceActiveFocus()
            Connections {
                target: root.flow
                function onIsResponseRequiredChanged() { if (root.flow.isResponseRequired && win.focused) input.forceActiveFocus(); }
            }

            Rectangle {
                id: card
                visible: win.focused
                anchors.centerIn: parent
                width: 400
                implicitHeight: col.implicitHeight + 40
                radius: Theme.cardRadius
                color: Theme.surface
                border.width: 1
                border.color: Theme.highlightHigh

                ColumnLayout {
                    id: col
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 20 }
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Icon { name: "lock"; size: 18; color: Theme.accent }
                        Text {
                            Layout.fillWidth: true
                            text: "Authentication required"
                            color: Theme.text; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize + 1; font.bold: true
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: root.flow?.message ?? ""
                        wrapMode: Text.Wrap
                        color: Theme.subtle; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }
                    Text {
                        Layout.fillWidth: true
                        visible: text !== ""
                        text: root.flow?.actionId ?? ""
                        elide: Text.ElideMiddle
                        color: Theme.muted; font.family: Theme.mono; font.pixelSize: Theme.uiFontSize - 2
                    }

                    // who is authenticating; a picker only when polkit offers a choice
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 4
                        spacing: 6
                        Repeater {
                            model: root.flow?.identities ?? []
                            delegate: Rectangle {
                                id: chip
                                required property var modelData
                                readonly property bool selected: root.flow?.selectedIdentity === modelData
                                readonly property bool pickable: (root.flow?.identities.length ?? 0) > 1
                                implicitWidth: chipLabel.implicitWidth + 20
                                implicitHeight: 24
                                radius: Theme.fieldRadius
                                color: selected && pickable ? Theme.highlightMed : chipHover.containsMouse && pickable ? Theme.hover : "transparent"
                                Text {
                                    id: chipLabel
                                    anchors.centerIn: parent
                                    text: chip.modelData.displayName || chip.modelData.string
                                    color: chip.selected ? Theme.text : Theme.subtle
                                    font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                                }
                                MouseArea {
                                    id: chipHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: chip.pickable
                                    onClicked: root.flow.selectedIdentity = chip.modelData
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: field
                        Layout.fillWidth: true
                        implicitHeight: 36
                        radius: Theme.fieldRadius
                        color: Theme.highlightLow
                        border.width: 1
                        border.color: input.activeFocus ? Theme.accent : Theme.highlightMed
                        opacity: root.waiting ? 0.6 : 1

                        TextInput {
                            id: input
                            anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                            verticalAlignment: TextInput.AlignVCenter
                            enabled: root.flow?.isResponseRequired ?? false
                            echoMode: root.flow?.responseVisible ? TextInput.Normal : TextInput.Password
                            passwordCharacter: "•"
                            color: Theme.text
                            selectionColor: Theme.highlightMed
                            selectedTextColor: Theme.text
                            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                            onAccepted: root.submit(input)
                            Keys.onEscapePressed: root.flow?.cancelAuthenticationRequest()
                        }
                        Text {
                            anchors { fill: input }
                            verticalAlignment: Text.AlignVCenter
                            visible: input.text === ""
                            text: (root.flow?.inputPrompt ?? "").replace(/:\s*$/, "") || "Password"   // pam says "Password:"
                            color: Theme.muted; font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: text !== ""
                        text: root.status()
                        wrapMode: Text.Wrap
                        color: root.flow?.supplementaryIsError || root.flow?.failed ? Theme.love : Theme.subtle
                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 4
                        spacing: 8
                        Item { Layout.fillWidth: true }
                        Button { label: "Cancel"; onClicked: root.flow?.cancelAuthenticationRequest() }
                        Button { label: "Authenticate"; primary: true; enabled: !root.waiting; onClicked: root.submit(input) }
                    }
                }
            }
        }
    }

    component Button: Rectangle {
        id: btn
        property string label
        property bool primary: false
        property bool enabled: true
        signal clicked()
        implicitWidth: btnLabel.implicitWidth + 28
        implicitHeight: 30
        radius: Theme.fieldRadius
        opacity: enabled ? 1 : 0.5
        color: primary ? (btnHover.containsMouse ? Qt.lighter(Theme.accent, 1.1) : Theme.accent)
                       : (btnHover.containsMouse ? Theme.highlightHigh : Theme.highlightMed)
        Text {
            id: btnLabel
            anchors.centerIn: parent
            text: btn.label
            color: btn.primary ? Theme.base : Theme.text
            font.family: Theme.ui; font.pixelSize: Theme.uiFontSize; font.bold: btn.primary
        }
        MouseArea { id: btnHover; anchors.fill: parent; hoverEnabled: true; enabled: btn.enabled; onClicked: btn.clicked() }
    }
}
