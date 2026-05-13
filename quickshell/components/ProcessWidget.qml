import QtQuick
import qs.services
import qs

Text {
    text: Process.activeTitle
    font: Globals.fonts.regular
    color: Globals.palette.text
    clip: true
}
