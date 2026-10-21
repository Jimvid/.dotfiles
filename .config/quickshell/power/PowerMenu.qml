import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs

// power menu on super+m (`qs ipc call power toggle`): every screen dims and blurs, the focused one shows a row of actions.
// arrows move, enter confirms (twice for anything but lock), escape closes. no letter hotkeys: the menu owns the keyboard
// while open, so a stray keystroke must never log out or power off
Scope {
    id: root
    property bool shown: false
    property int selected: 0
    property bool armed: false      // a destructive action was confirmed once; the next enter runs it

    readonly property var actions: [
        { label: "Lock",     icon: "lock",       safe: true,  cmd: "pidof hyprlock || hyprlock" },
        { label: "Log out",  icon: "log-out",    safe: false, cmd: "hyprctl dispatch 'hl.dsp.exit()'" },
        { label: "Suspend",  icon: "moon",       safe: false, cmd: "systemctl suspend" },
        { label: "Reboot",   icon: "rotate-ccw", safe: false, cmd: "systemctl reboot" },
        { label: "Shutdown", icon: "power",      safe: false, cmd: "systemctl poweroff" },
    ]

    function select(i) { if (i !== selected) armed = false; selected = i; }
    function confirm(i) {
        select(i);
        if (!actions[i].safe && !armed) { armed = true; return; }
        root.shown = false;
        Quickshell.execDetached(["sh", "-c", actions[i].cmd]);
    }
    onShownChanged: armed = false

    IpcHandler {
        target: "power"
        function toggle(): void { root.selected = 0; root.armed = false; root.shown = !root.shown; }
    }

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: win
            required property var modelData
            screen: modelData
            readonly property bool focused: (Hyprland.focusedMonitor?.name ?? Quickshell.screens[0]?.name) === modelData.name   // modelData, not screen: the window's screen gets reassigned while a monitor goes away
            visible: root.shown

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs-power"
            WlrLayershell.keyboardFocus: focused && visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Ignore
            anchors { top: true; bottom: true; left: true; right: true }
            color: "transparent"

            Rectangle { anchors.fill: parent; color: Theme.base; opacity: 0.55 }
            MouseArea { anchors.fill: parent; onClicked: root.shown = false }   // click outside the card closes

            onVisibleChanged: if (visible && focused) keys.forceActiveFocus()
            Item {
                id: keys
                anchors.fill: parent
                focus: win.focused
                Keys.onPressed: event => {
                    const n = root.actions.length;
                    if (event.key === Qt.Key_Escape) root.shown = false;
                    else if (event.key === Qt.Key_Left) root.select((root.selected + n - 1) % n);
                    else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab) root.select((root.selected + 1) % n);
                    else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) root.confirm(root.selected);
                    else return;
                    event.accepted = true;
                }
            }

            Rectangle {
                id: card
                visible: win.focused
                anchors.centerIn: parent
                width: col.implicitWidth + 40
                height: col.implicitHeight + 40
                radius: Theme.cardRadius
                color: Theme.surface
                border.width: 1
                border.color: Theme.highlightHigh
                MouseArea { anchors.fill: parent }   // keep clicks on the card from closing it

                ColumnLayout {
                    id: col
                    anchors.centerIn: parent
                    spacing: 14

                    RowLayout {
                        spacing: 8
                        Repeater {
                            model: root.actions
                            delegate: Rectangle {
                                id: tile
                                required property var modelData
                                required property int index
                                readonly property bool active: root.selected === index
                                implicitWidth: 92; implicitHeight: 84
                                radius: Theme.cardRadius
                                color: active ? Theme.highlightMed : tileHover.containsMouse ? Theme.hover : "transparent"

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    Icon {
                                        Layout.alignment: Qt.AlignHCenter
                                        name: tile.modelData.icon; size: 22
                                        color: tile.active ? Theme.accent : Theme.subtle
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: tile.modelData.label
                                        color: tile.active ? Theme.text : Theme.subtle
                                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize
                                    }
                                }
                                MouseArea {
                                    id: tileHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: root.select(tile.index)
                                    onClicked: root.confirm(tile.index)
                                }
                            }
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.armed ? "enter again to " + root.actions[root.selected].label.toLowerCase() : "←  →  move     enter  confirm     esc  close"
                        color: root.armed ? Theme.love : Theme.muted
                        font.family: Theme.ui; font.pixelSize: Theme.uiFontSize - 2
                    }
                }
            }
        }
    }
}
