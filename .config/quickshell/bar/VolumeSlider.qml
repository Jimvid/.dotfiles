import QtQuick
import qs

// horizontal 0..1 slider in theme colours: a tall filled bar with no knob; emits moved(value) on drag, click and scroll
Item {
    id: root
    property real value: 0
    property bool active: true   // false draws the fill in the muted colour
    signal moved(real value)
    implicitHeight: 28

    function clamp(v) { return Math.max(0, Math.min(1, v)); }

    Rectangle {
        id: trough
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width; height: 20; radius: Theme.fieldRadius
        color: Theme.highlightMed
        clip: true

        Rectangle {
            width: Math.max(parent.radius * 2, parent.width * root.clamp(root.value))
            height: parent.height; radius: parent.radius
            color: root.active ? Theme.accent : Theme.subtle
            opacity: area.containsMouse || area.pressed ? 1 : 0.85
            Behavior on width { NumberAnimation { duration: 40 } }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onPressed: mouse => root.moved(root.clamp(mouse.x / root.width))
        onPositionChanged: mouse => { if (pressed) root.moved(root.clamp(mouse.x / root.width)); }
        onWheel: wheel => root.moved(root.clamp(root.value + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)))
    }
}
