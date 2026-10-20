import Quickshell
import QtQuick
import qs

// a tray item's right-click menu, drawn like the other dropdowns instead of the stock platform menu.
// entries are fetched over dbus before the popup maps, so it opens at its final size
PopupWindow {
    id: popup
    required property Item target
    required property var handle
    visible: false
    grabFocus: true

    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.bottom: -Theme.popupGap   // margins shrink the anchor rect; a negative bottom margin grows it downward, pushing the popup away

    color: "transparent"
    implicitWidth: Math.max(200, Math.min(360, (loader.item?.implicitWidth ?? 0) + 16))
    implicitHeight: card.implicitHeight

    property bool pending: false
    function open() {
        if (visible) { visible = false; return; }
        loader.active = true;
        if ((loader.item?.count ?? 0) > 0) visible = true;
        else pending = true;
    }
    function close() { visible = false; }
    onVisibleChanged: if (!visible) { pending = false; loader.active = false; }   // drop the entries so the next open re-fetches them

    Rectangle {
        id: card
        width: parent.width
        radius: Theme.cardRadius
        color: Theme.surface
        border.width: 1
        border.color: Theme.highlightHigh
        implicitHeight: (loader.item?.implicitHeight ?? 0) + 16

        Loader {
            id: loader
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
            active: false
            sourceComponent: TrayMenuList {
                width: loader.width
                handle: popup.handle
                onActivated: popup.close()
                onCountChanged: if (popup.pending && count > 0) { popup.pending = false; popup.visible = true; }
            }
        }
    }
}
