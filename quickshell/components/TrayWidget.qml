import QtQuick
import QtQuick.Layouts
import qs
import qs.services

RowLayout {
    id: root
    Repeater {
        model: Tray.items

        delegate: Text {
            required property string id
            text: id
            font: Globals.fonts.regular
            color: Globals.palette.text
        }
    }
}
