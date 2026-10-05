import QtQuick
import QtQuick.Layouts
import qs

Item {
    id: root

    property string text: ""
    property string icon: ""
    property real value: 0
    property color color: Globals.palette.text
    property int spacing: 1
    property real widgetWidth: Globals.informationWidget.width

    implicitWidth: widgetWidth
    implicitHeight: label.implicitHeight + spacing + bar.implicitHeight
    width: implicitWidth
    height: implicitHeight

    RowLayout {
        id: label
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 3

        Text {
            id: textItem
            text: root.text
            font: Globals.fonts.regular
            color: root.color
            elide: Text.ElideRight
            Layout.maximumWidth: root.width - (iconItem.visible ? iconItem.implicitWidth + label.spacing : 0)
            Layout.alignment: Qt.AlignBaseline
        }

        Text {
            id: iconItem
            visible: root.icon !== ""
            text: root.icon
            font: Globals.fonts.monospace
            color: root.color
            Layout.alignment: Qt.AlignBaseline
        }
    }

    ProgressBar {
        id: bar
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: root.width
        value: root.value
        color: root.color
    }
}
