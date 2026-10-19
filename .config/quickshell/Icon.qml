import QtQuick
import QtQuick.Effects
import qs

// a lucide icon from icons/, tinted to `color`
Item {
    id: root
    required property string name
    property color color: Theme.fg
    property int size: 16
    implicitWidth: size
    implicitHeight: size

    Image {
        id: img
        anchors.fill: parent
        source: root.name !== "" ? Qt.resolvedUrl("icons/" + root.name + ".svg") : ""
        sourceSize: Qt.size(root.size * 2, root.size * 2)
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: false
    }

    MultiEffect {
        source: img
        anchors.fill: img
        colorization: 1.0
        colorizationColor: root.color
    }
}
