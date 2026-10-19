import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs

// the stack of cards in the top right corner of the focused screen, just below the bar.
// the window is a fixed full-height strip that stays mapped, so hyprland never fades it in or out;
// only the cards themselves take input, everything else passes through
Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: win
        required property var modelData
        screen: modelData
        readonly property bool focused: (Hyprland.focusedMonitor?.name ?? Quickshell.screens[0]?.name) === screen.name
        visible: focused

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-notifications"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: 0
        anchors { top: true; bottom: true; right: true }
        margins { top: Theme.popupGap - Theme.barMargin; right: Theme.sideMargin }
        implicitWidth: 360
        color: "transparent"
        mask: Region { item: stack }

        Column {
            id: stack
            width: parent.width
            spacing: Theme.popupGap

            add:  Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 } }
            move: Transition { NumberAnimation { property: "y"; duration: 150; easing.type: Easing.OutCubic } }

            Repeater {
                model: Notifs.popups
                delegate: NotificationCard {
                    id: card
                    required property int nid
                    required property var notif
                    required property bool closing
                    required appName
                    required summary
                    required body
                    required urgency
                    required icon

                    width: stack.width
                    actions: notif?.actions ?? []
                    opacity: closing ? 0 : 1
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    Timer { running: card.closing; interval: 160; onTriggered: Notifs.remove(card.nid) }

                    onCloseClicked: notif?.dismiss()
                    onClicked: {
                        if (!notif) return;
                        const d = notif.actions.find(a => a.identifier === "default");
                        if (d) d.invoke();
                        notif.dismiss();
                    }

                    // auto-expire, paused while the mouse is over the card; only the window on the focused screen counts down
                    Timer {
                        interval: card.notif ? Notifs.timeout(card.notif) : 0
                        running: interval > 0 && win.visible && !card.closing && !card.hovered
                        onTriggered: card.notif?.expire()
                    }
                }
            }
        }
    }
}
