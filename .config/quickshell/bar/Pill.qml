import QtQuick
import qs

// rounded group container; children land in the row
Rectangle {
    default property alias content: row.data
    radius: Theme.pillRadius
    color: Theme.base
    implicitHeight: Theme.barHeight
    implicitWidth: row.implicitWidth

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.spacing
    }
}
