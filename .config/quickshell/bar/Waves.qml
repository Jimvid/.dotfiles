import QtQuick
import qs

// a small soundwave: four bars that glide between a low and a high height on their own beat while `running`, dots when not
Item {
    id: root
    property bool running: false
    property color color: Theme.accent
    implicitWidth: bars.implicitWidth
    implicitHeight: Theme.barHeight

    Row {
        id: bars
        anchors.centerIn: parent
        spacing: 2
        Repeater {
            model: [ { d: 900, hi: 9 }, { d: 1100, hi: 8 }, { d: 800, hi: 10 }, { d: 1000, hi: 8 } ]
            delegate: Rectangle {
                id: bar
                required property var modelData
                required property int index
                readonly property int lo: 5
                anchors.verticalCenter: parent.verticalCenter
                width: 3
                height: root.running ? lo : 4
                radius: 1.5
                color: root.color

                // up, down, up, down: one smooth move each beat, started a little later per bar
                SequentialAnimation on height {
                    running: root.running
                    loops: Animation.Infinite
                    PauseAnimation { duration: bar.index * 220 }
                    NumberAnimation { to: bar.modelData.hi; duration: bar.modelData.d; easing.type: Easing.InOutSine }
                    NumberAnimation { to: bar.lo; duration: bar.modelData.d; easing.type: Easing.InOutSine }
                }
            }
        }
    }
}
