pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// the laptop panel backlight through brightnessctl, in the same exponential curve the media keys use
Singleton {
    id: root
    property int percent: 0
    property bool available: false

    function refresh() { read.running = true; }
    function set(p) {
        p = Math.max(1, Math.min(100, Math.round(p)));
        percent = p;   // optimistic, so a slider drag feels immediate
        apply.command = ["brightnessctl", "-e4", "-q", "set", p + "%"];
        apply.running = true;
    }
    function step(delta) { set(percent + delta); }

    Process {
        id: read
        running: true
        command: ["brightnessctl", "-e4", "-m"]   // intel_backlight,backlight,96000,100%,96000
        stdout: StdioCollector {
            onStreamFinished: {
                const m = text.match(/,(\d+)%,/);
                root.available = m !== null;
                if (m) root.percent = parseInt(m[1]);
            }
        }
    }
    Process { id: apply; onExited: root.refresh() }
}
