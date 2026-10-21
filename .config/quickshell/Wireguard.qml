pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// the WireGuard profiles NetworkManager knows (install/vpn.sh imports them)
Singleton {
    id: root
    property var profiles: []          // [{ name, active, server, endpoint, address, rx, tx }]
    property string publicIp: ""
    property string error: ""
    readonly property var active: profiles.filter(p => p.active)
    readonly property bool busy: action.running

    function refresh() { if (!poll.running) poll.running = true; }
    function lookup() { if (!ipProc.running) ipProc.running = true; }
    function up(name) { run(["nmcli", "connection", "up", name]); }
    function down(name) { run(["nmcli", "connection", "down", name]); }
    // the header switch: off drops every tunnel, on brings back the last one used
    property string last: ""
    function toggle() {
        if (active.length) active.forEach(p => down(p.name));
        else if (profiles.length) up(profiles.find(p => p.name === last)?.name ?? profiles[0].name);
    }

    // one tunnel at a time: picking a profile drops whatever is up, picking the active one drops it
    function select(name) {
        last = name;
        const quote = s => "'" + s.replace(/'/g, "'\\''") + "'";
        if (active.some(p => p.name === name)) { down(name); return; }
        run(["sh", "-c", active.map(p => "nmcli connection down " + quote(p.name) + ";").join(" ") + " nmcli connection up " + quote(name)]);
    }
    function run(cmd) {
        if (action.running) return;
        error = "";
        action.command = cmd;
        action.running = true;
    }

    // the exit address changes with the tunnel
    onActiveChanged: { if (active.length) last = active[0].name; lookup(); }

    Process {
        id: action
        stderr: StdioCollector { id: actionErr }
        onExited: code => {
            if (code !== 0) root.error = actionErr.text.trim().split("\n").pop().replace(/^Error: /, "") || "Failed";
            root.refresh();
        }
    }

    // one line per profile: name|active|server|endpoint|address|rx|tx. the profile name is what
    // NetworkManager shows; the tunnel interface names the config file and the sysfs counters. the
    // server name is the comment Proton puts under [Peer] in the config
    Process {
        id: poll
        command: ["sh", "-c", `
            nmcli -t -f NAME,TYPE,ACTIVE connection show | while IFS=: read -r name type active; do
                [ "$type" = wireguard ] || continue
                iface=$(nmcli -g connection.interface-name connection show "$name")
                conf="$HOME/.config/wireguard/$iface.conf"
                server=; [ -f "$conf" ] && server=$(sed -n '/^\\[Peer\\]/,$p' "$conf" | grep -m1 '^# ' | cut -c3-)
                endpoint=$(nmcli -g wireguard.peers connection show "$name" | sed -n 's/.*endpoint=\\([^ :]*\\).*/\\1/p' | head -1)
                address=$(nmcli -g ipv4.addresses connection show "$name" | sed 's,/.*,,')
                rx=0; tx=0
                if [ "$active" = yes ] && [ -d "/sys/class/net/$iface" ]; then
                    rx=$(cat "/sys/class/net/$iface/statistics/rx_bytes"); tx=$(cat "/sys/class/net/$iface/statistics/tx_bytes")
                fi
                echo "$name|$active|$server|$endpoint|$address|$rx|$tx"
            done`]
        stdout: StdioCollector {
            onStreamFinished: {
                const list = text.trim().split("\n").filter(l => l !== "").map(l => {
                    const f = l.split("|");
                    return { name: f[0], active: f[1] === "yes", server: f[2], endpoint: f[3], address: f[4], rx: parseInt(f[5]) || 0, tx: parseInt(f[6]) || 0 };
                });
                // keep the array when nothing changed so bindings on it stay quiet
                if (JSON.stringify(list) !== JSON.stringify(root.profiles)) root.profiles = list;
            }
        }
    }
    Process {
        id: ipProc
        command: ["curl", "-s", "--max-time", "5", "https://api.ipify.org"]
        stdout: StdioCollector { onStreamFinished: root.publicIp = text.trim() }
    }
    Timer {
        interval: root.busy ? 2000 : 10000
        repeat: true; running: true; triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
