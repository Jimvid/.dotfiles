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

    readonly property var icons: ["\u{f007b}", "\u{f007c}", "\u{f007e}", "\u{f0080}", "\u{f0082}", "\u{f0079}"]
    readonly property string icon: charging ? "\u{f0084}" : icons[Math.min(5, Math.floor(pct / 100 * 6))]

    function fmt(s) { const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60); return h + ":" + (m < 10 ? "0" : "") + m; }

    text: (showTime ? fmt(charging ? dev.timeToFull : dev.timeToEmpty) : pct + "%") + "  " + icon + " "
    color: critical ? Theme.text : warning ? Theme.love : charging ? Theme.pine : Theme.accent
    tip: charging ? (dev.state === UPowerDeviceState.FullyCharged ? "full" : fmt(dev.timeToFull) + " until full")
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
