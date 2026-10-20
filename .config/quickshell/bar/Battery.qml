import Quickshell
import Quickshell.Services.UPower
import QtQuick
import qs

Glyph {
    id: root
    readonly property UPowerDevice dev: UPower.displayDevice
    visible: dev.ready && dev.isLaptopBattery

    readonly property int pct: Math.round(dev.percentage * 100)
    readonly property bool charging: dev.state === UPowerDeviceState.Charging
                                  || dev.state === UPowerDeviceState.FullyCharged
                                  || dev.state === UPowerDeviceState.PendingCharge
    readonly property bool warning:  !charging && pct <= 30
    readonly property bool critical: !charging && pct <= 20
    property bool showTime: false


    function fmt(s) { const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60); return h + ":" + (m < 10 ? "0" : "") + m; }

    // low battery warnings through the shell's own notification server: once at 20%, once more (critical) at 10%, reset when charging
    property int warnedAt: 100
    function warn(level, urgency, body) {
        const icon = Qt.resolvedUrl("../icons/battery-warning.svg").toString().replace("file://", "");
        Quickshell.execDetached(["notify-send", "-a", "Battery", "-u", urgency, "-i", icon, "Battery " + level, body]);
    }
    onPctChanged: {
        if (charging) return;
        if (pct <= 10 && warnedAt > 10) { warnedAt = 10; warn("critical", "critical", pct + "% left, plug in now"); }
        else if (pct <= 20 && warnedAt > 20) { warnedAt = 20; warn("low", "normal", pct + "% left" + (dev.timeToEmpty > 0 ? ", about " + fmt(dev.timeToEmpty) + " remaining" : "")); }
    }
    onChargingChanged: if (charging) warnedAt = 100

    text: showTime ? fmt(charging ? dev.timeToFull : dev.timeToEmpty) : pct + "%"
    icon: charging ? "battery-charging" : critical ? "battery-warning"
        : pct > 80 ? "battery-full" : pct > 45 ? "battery-medium" : pct > 15 ? "battery-low" : "battery"
    color: critical ? Theme.base : warning ? Theme.gold : charging ? Theme.pine : Theme.fg
    tip: charging ? (dev.state === UPowerDeviceState.FullyCharged ? "Full" : fmt(dev.timeToFull) + " until full")
                  : fmt(dev.timeToEmpty) + " left"
    onClicked: showTime = !showTime

    // critical: blink like the waybar css did
    Rectangle {
        anchors.fill: parent
        z: -1
        radius: Theme.pillRadius
        visible: root.critical
        color: Theme.love
        SequentialAnimation on opacity {
            running: root.critical; loops: Animation.Infinite
            NumberAnimation { to: 0.2; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
    }
}
