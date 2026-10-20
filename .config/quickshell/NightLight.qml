pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// night light through hyprsunset: a warm colour temperature when on, the daemon's neutral 6000K when off
// (not `identity`, which leaves the reported temperature where it was). state is read back from the daemon
// at startup so a reload does not flip the toggle
Singleton {
    id: root
    property bool on: false
    readonly property int temperature: 4000
    readonly property int neutral: 6000

    function set(v) {
        on = v;
        apply.command = ["hyprctl", "hyprsunset", "temperature", String(v ? temperature : neutral)];
        apply.running = true;
    }
    function toggle() { set(!on); }

    Process { id: apply }
    Process {
        id: query
        running: true
        command: ["hyprctl", "hyprsunset", "temperature"]
        stdout: StdioCollector { onStreamFinished: { const t = parseInt(text); if (!isNaN(t)) root.on = t < 5500; } }
    }
}
