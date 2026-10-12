import QtQuick
import qs

Item {
    id: root

    property real value: 0
    property bool vertical: false
    property color color: Globals.palette.text
    property color trackColor: Globals.palette.surface

    // Try to make the bar look like the one on the top bar.
    implicitWidth: vertical ? 2 : 20
    implicitHeight: vertical ? 20 : 2
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: root.vertical ? width / 2 : height / 2
        color: root.trackColor
    }

    Rectangle {
        anchors.left: root.vertical ? undefined : parent.left
        anchors.bottom: root.vertical ? parent.bottom : undefined
        width: root.vertical ? parent.width : parent.width * Math.max(0, Math.min(1, root.value))
        height: root.vertical ? parent.height * Math.max(0, Math.min(1, root.value)) : parent.height
        radius: root.vertical ? width / 2 : height / 2
        color: root.color
    }
}
