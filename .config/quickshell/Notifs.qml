pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// the notification server: cards currently on screen, a history of everything received, and do-not-disturb
Singleton {
    id: root
    property bool dnd: false
    readonly property ListModel popups: ListModel { id: popupModel }   // cards on screen, oldest first; a closing card fades out before it is removed
    property var history: []    // plain snapshots, newest first; they outlive the notification being closed
    property int unread: 0
    readonly property int maxHistory: 50

    readonly property int timeout: 3000   // milliseconds a card stays up, whatever the app asked for

    // an app icon as an Image source: absolute paths pass through, names go through the icon theme
    function iconSource(name) {
        if (!name) return "";
        if (name.startsWith("/") || name.startsWith("file://")) return name;
        return Quickshell.iconPath(name, true);
    }

    function indexOf(nid) { for (let i = 0; i < popupModel.count; i++) if (popupModel.get(i).nid === nid) return i; return -1; }
    function remove(nid) { const i = indexOf(nid); if (i >= 0) popupModel.remove(i); }
    function clearHistory() { history = []; unread = 0; }
    function forget(id) { history = history.filter(h => h.id !== id); }
    function dismissAll() { for (let i = 0; i < popupModel.count; i++) popupModel.get(i).notif?.dismiss(); }

    NotificationServer {
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        imageSupported: true
        onNotification: n => {
            const icon = root.iconSource(n.appIcon) || root.iconSource(n.desktopEntry);
            root.history = [{
                id: n.id, time: Date.now(),
                appName: n.appName, summary: n.summary, body: n.body, urgency: n.urgency, icon: icon,
            }].concat(root.history).slice(0, root.maxHistory);
            root.unread++;

            // do not disturb swallows everything but critical; untracked notifications are dropped by the server
            if (root.dnd && n.urgency !== NotificationUrgency.Critical) return;
            n.tracked = true;
            const nid = n.id;
            n.closed.connect(() => { const i = root.indexOf(nid); if (i >= 0) popupModel.setProperty(i, "closing", true); });
            popupModel.append({
                nid: nid, notif: n, closing: false,
                appName: n.appName, summary: n.summary, body: n.body, urgency: n.urgency,
                icon: n.image || icon,
            });
        }
    }
}
