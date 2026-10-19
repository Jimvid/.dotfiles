import Quickshell
import QtQuick
import qs

Glyph {
    id: root
    SystemClock { id: clock; precision: SystemClock.Minutes }

    // 12-hour without am/pm, like waybar's %I:%M; midnight is 12 not 0
    readonly property int hour12: ((clock.hours + 11) % 12) + 1
    text: (hour12 < 10 ? "0" : "") + hour12 + ":" + (clock.minutes < 10 ? "0" : "") + clock.minutes
    tip: Qt.formatDate(clock.date, "dddd d MMMM yyyy")

    onClicked: calendar.visible = !calendar.visible
    CalendarPopup { id: calendar; target: root }
}
