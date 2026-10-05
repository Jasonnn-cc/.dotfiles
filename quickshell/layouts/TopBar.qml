import Quickshell
import QtQuick
import QtQuick.Layouts

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

    RowLayout {
        id: centerRow
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        spacing: Globals.topBar.spacing
    }
    RowLayout {
        id: leftRow
        anchors {
            left: parent.left
            leftMargin: Globals.topBar.padding
            right: centerRow.left
            rightMargin: Globals.topBar.spacing
            verticalCenter: parent.verticalCenter
        }
        spacing: Globals.topBar.spacing
        clip: true
    }
    RowLayout {
        id: rightRow
        anchors {
            left: centerRow.right
            leftMargin: Globals.topBar.spacing
            right: parent.right
            rightMargin: Globals.topBar.padding
            verticalCenter: parent.verticalCenter
        }
        spacing: Globals.topBar.spacing
        clip: true

        Item {
            Layout.fillWidth: true
        }
    }

    Component.onCompleted: {
        for (var item of left)
            item.parent = leftRow;
        for (var item of center)
            item.parent = centerRow;
        for (var item of right)
            item.parent = rightRow;
    }
}
