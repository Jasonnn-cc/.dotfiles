import QtQuick
import qs
import qs.services

ProgressBar {
    id: root

    vertical: true
    visible: WorkTimer.active
    implicitHeight: Globals.topBar.height - 4
    value: WorkTimer.progress
    color: Globals.palette.accent

    HoverHandler {
        id: hover
        // The bar is only 2px wide, so make it easier to hover.
        margin: 6
    }

    Tooltip {
        target: root
        visible: hover.hovered && WorkTimer.active
        text: WorkTimer.remaining + " left"
    }
}
