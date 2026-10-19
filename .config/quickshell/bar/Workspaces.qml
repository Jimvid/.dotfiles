import Quickshell.Hyprland
import QtQuick
import qs

Row {
    id: root
    required property var screen
    readonly property var monitor: Hyprland.monitorFor(screen)

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
        delegate: Glyph {
            required property int modelData
            readonly property bool active: root.monitor?.activeWorkspace?.id === modelData
            readonly property bool urgent: root.workspace(modelData)?.urgent ?? false
            text: active ? "" : ""
            color: urgent ? Theme.love : active ? Theme.accentContrast : Theme.accent
            padding: 6
            onClicked: root.go(modelData)
            onScrolled: delta => {
                const i = root.ids.indexOf(root.monitor?.activeWorkspace?.id ?? modelData);
                const n = root.ids[Math.min(root.ids.length - 1, Math.max(0, i + (delta < 0 ? 1 : -1)))];
                if (n !== undefined) root.go(n);
            }
        }
    }
}
