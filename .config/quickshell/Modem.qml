pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// the 5g modem through ModemManager; data goes through the NetworkManager profile "wwan" (install/wwan.sh)
Singleton {
    id: root
    property bool present: false
    property string mmState: ""        // modemmanager: disabled, registered, connecting, connected, ...
    property string iface: "wwan0"     // the modem's net port
    property string operator: ""
    property string tech: ""           // 5G / 4G / 3G / 2G
    property int quality: 0            // signal, percent
    property string error: ""
    readonly property bool connected: mmState === "connected"
    readonly property bool busy: action.running || ["enabling", "connecting", "disconnecting", "disabling"].includes(mmState)

    function refresh() { if (!poll.running) poll.running = true; }
    function enable() { run("nmcli radio wwan on && nmcli connection up wwan"); }
    function disable() { run("nmcli radio wwan off"); }   // drops the connection and powers the radio down
    function run(cmd) {
        if (action.running) return;
        error = "";
        action.command = ["sh", "-c", cmd];
        action.running = true;
    }

    function techName(list) {
        if (list.includes("5gnr")) return "5G";
        if (list.includes("lte")) return "4G";
        if (list.some(t => /umts|hsdpa|hsupa|hspa/.test(t))) return "3G";
        return list.length ? "2G" : "";
    }

    Process {
        id: action
        stderr: StdioCollector { id: actionErr }
        onExited: code => {
            if (code !== 0) root.error = actionErr.text.trim().split("\n").pop().replace(/^Error: /, "") || "Failed";
            root.refresh();
        }
    }

    Process {
        id: poll
        command: ["sh", "-c", "mmcli -m any -J 2>/dev/null || echo null"]
        stdout: StdioCollector {
            onStreamFinished: {
                let m = null;
                try { m = JSON.parse(text)?.modem ?? null; } catch (e) {}
                root.present = m !== null;
                if (!m) return;
                root.mmState = m.generic.state;
                root.iface = (m.generic.ports ?? []).map(p => p.match(/^(\S+) \(net\)$/)?.[1]).find(p => p) ?? "wwan0";
                const op = m["3gpp"]?.["operator-name"] ?? "";
                root.operator = op === "--" ? "" : op;
                root.tech = root.techName(m.generic["access-technologies"] ?? []);
                root.quality = parseInt(m.generic["signal-quality"]?.value ?? "0") || 0;
            }
        }
    }
    Timer {
        interval: root.busy ? 2000 : 10000
        repeat: true; running: true; triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
