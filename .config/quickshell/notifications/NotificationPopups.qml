import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs

// the stack of cards in the top right corner of the focused screen, just below the bar.
// the window is a fixed full-height strip that stays mapped, so hyprland never fades it in or out;
// it runs to the screen edge so a card slides in from off screen and back out the same way.
// only the cards themselves take input, everything else passes through
Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: win
        required property var modelData
        screen: modelData
        readonly property bool focused: (Hyprland.focusedMonitor?.name ?? Quickshell.screens[0]?.name) === modelData.name   // modelData, not screen: the window's screen gets reassigned while a monitor goes away
        visible: focused

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-notifications"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: 0
        anchors { top: true; bottom: true; right: true }
        margins { top: Theme.popupGap }
        implicitWidth: 360 + Theme.sideMargin
        color: "transparent"
        mask: Region { item: stack }

        Column {
            id: stack
            width: 360
            anchors { right: parent.right; rightMargin: Theme.sideMargin }
            spacing: Theme.popupGap
            readonly property int offscreen: width + Theme.sideMargin   // a card's x once it is past the screen edge

            add:  Transition { NumberAnimation { property: "x"; from: stack.offscreen; to: 0; duration: 250; easing.type: Easing.OutCubic } }
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
                    x: closing ? stack.offscreen : 0
                    Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.InCubic } }
                    Timer { running: card.closing; interval: 210; onTriggered: Notifs.remove(card.nid) }

                    onCloseClicked: notif?.dismiss()
                    onClicked: {
                        if (!notif) return;
                        const d = notif.actions.find(a => a.identifier === "default");
                        if (d) d.invoke();
                        notif.dismiss();
                    }

                    // auto-expire, paused while the mouse is over the card; only the window on the focused screen counts down
                    Timer {
                        interval: Notifs.timeout
                        running: win.visible && !card.closing && !card.hovered
                        onTriggered: card.notif?.expire()
                    }
                }
            }
        }
    }
}
