import Quickshell
import QtQuick

import qs

PanelWindow {
    property list<Item> left
    property list<Item> center
    property list<Item> right

    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Globals.topBar.height

    Row {
        id: leftRow
        anchors {
            verticalCenter: parent.verticalCenter
        }
        leftPadding: Globals.topBar.padding
        spacing: Globals.topBar.spacing
    }
    Row {
        id: centerRow
        anchors {
            centerIn: parent
            verticalCenter: parent.verticalCenter
        }
        spacing: Globals.topBar.spacing
    }
    Row {
        id: rightRow
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        rightPadding: Globals.topBar.padding
        spacing: Globals.topBar.spacing
    }

    Component.onCompleted: {
        for (var item of left) {
            item.parent = leftRow;
            item.anchors.verticalCenter = leftRow.verticalCenter;
        }
        for (var item of center) {
            item.parent = centerRow;
            item.anchors.verticalCenter = centerRow.verticalCenter;
        }
        for (var item of right) {
            item.parent = rightRow;
            item.anchors.verticalCenter = rightRow.verticalCenter;
        }
    }
}
