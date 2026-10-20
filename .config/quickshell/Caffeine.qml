pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// keeps the machine awake by holding a logind idle inhibitor, which hypridle honours; `qs ipc call caffeine toggle` from a bind
Singleton {
    id: root
    property bool active: false
    property int minutes: 0          // 0 = until turned off
    property real until: 0           // epoch ms when it ends, 0 for no end
    property real now: Date.now()

    readonly property var options: [
        { label: "Until turned off", minutes: 0 },
        { label: "30 minutes",       minutes: 30 },
        { label: "1 hour",           minutes: 60 },
        { label: "4 hours",          minutes: 240 },
        { label: "8 hours",          minutes: 480 },
    ]

    readonly property string remaining: {
        if (!active) return "";
        if (until === 0) return "until turned off";
        const m = Math.max(0, Math.ceil((until - now) / 60000));
        return m >= 60 ? Math.floor(m / 60) + "h " + (m % 60 ? m % 60 + "m" : "") + " left" : m + "m left";
    }

    function start(mins) {
        if (active) inhibit.running = false;   // a fresh process picks up the new duration
        minutes = mins;
        until = mins > 0 ? Date.now() + mins * 60000 : 0;
        now = Date.now();
        active = true;
        inhibit.running = true;
    }
    function stop() { active = false; inhibit.running = false; }
    function toggle() { active ? stop() : start(minutes); }

    Process {
        id: inhibit
        command: ["systemd-inhibit", "--what=idle", "--who=Caffeine", "--why=Keeping the screen awake", "--mode=block",
                  "sleep", root.minutes > 0 ? String(root.minutes * 60) : "infinity"]
        onExited: if (root.active && !running) root.active = false   // the timer ran out
    }
    Timer { interval: 30000; repeat: true; running: root.active; onTriggered: root.now = Date.now() }

    IpcHandler {
        target: "caffeine"
        function toggle(): void { root.toggle(); }
        function start(minutes: int): void { root.start(minutes); }
        function stop(): void { root.stop(); }
    }
}
