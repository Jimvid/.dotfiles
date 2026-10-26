import Quickshell.Hyprland
import QtQuick
import qs

// a filled dot per workspace; the active one stretches into a rounded bar
Row {
    id: root
    required property var screen
    readonly property var monitor: Hyprland.monitorFor(screen)
    readonly property int dot: 6     // dot diameter, also the bar's thickness
    readonly property int bar: 22    // length of the active bar

    // 1-4 always shown, plus any higher workspace that exists on this monitor
    readonly property var ids: {
        const s = new Set([1, 2, 3, 4]);
        for (const ws of Hyprland.workspaces.values)
            if (ws.id > 0 && ws.monitor && root.monitor && ws.monitor.name === root.monitor.name) s.add(ws.id);
        return Array.from(s).sort((a, b) => a - b);
    }

    function workspace(id) { return Hyprland.workspaces.values.find(w => w.id === id) ?? null; }
    function go(id) {
        const ws = workspace(id);
        if (ws) ws.activate();
        else Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus({ workspace = ${id} })` : `workspace ${id}`);
    }

    Repeater {
        model: root.ids
        delegate: Item {
            id: item
            required property int modelData
            readonly property bool active: root.monitor?.activeWorkspace?.id === modelData
            readonly property bool urgent: root.workspace(modelData)?.urgent ?? false
            implicitWidth: mark.width + 2 * Theme.pillPadding
            implicitHeight: Theme.barHeight

            Rectangle {
                id: mark
                anchors.centerIn: parent
                width: item.active ? root.bar : root.dot
                height: root.dot
                radius: height / 2
                color: item.urgent ? Theme.love : item.active || area.containsMouse ? Theme.accent : Theme.fg
                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.go(item.modelData)
                onWheel: wheel => {
                    const i = root.ids.indexOf(root.monitor?.activeWorkspace?.id ?? item.modelData);
                    const n = root.ids[Math.min(root.ids.length - 1, Math.max(0, i + (wheel.angleDelta.y < 0 ? 1 : -1)))];
                    if (n !== undefined) root.go(n);
                }
            }
        }
    }
}
