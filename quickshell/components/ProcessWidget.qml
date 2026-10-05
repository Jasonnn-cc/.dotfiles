import QtQuick
import QtQuick.Layouts
import qs.services
import qs

Text {
    text: Process.activeTitle
    font: Globals.fonts.regular
    color: Globals.palette.text
    clip: true

    Layout.fillWidth: true
}
