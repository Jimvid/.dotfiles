import qs

// notification bell: dot while there is something unread, crossed out in do-not-disturb; click for the history, right click toggles do-not-disturb
Glyph {
    id: root
    icon: Notifs.dnd ? "bell-off" : Notifs.unread > 0 ? "bell-dot" : "bell"
    color: Notifs.dnd ? Theme.subtle : Theme.fg
    tip: Notifs.dnd ? "Do not disturb" : Notifs.unread === 0 ? "No new notifications" : Notifs.unread + " new"
    onClicked: mouse => {
        if (mouse.button === Qt.RightButton) Notifs.dnd = !Notifs.dnd;
        else if (mouse.button === Qt.MiddleButton) Notifs.dismissAll();
        else popup.visible = !popup.visible;
    }
    NotificationHistory { id: popup; target: root }
}
