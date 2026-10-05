import QtQuick
import qs

Item {
    id: root

    property real value: 0
    property color color: Globals.palette.text
    property color trackColor: Globals.palette.surface

    implicitWidth: 20
    implicitHeight: 2
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor
    }

    Rectangle {
        width: parent.width * Math.max(0, Math.min(1, root.value))
        height: parent.height
        radius: height / 2
        color: root.color
    }
}
