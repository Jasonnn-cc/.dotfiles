import QtQuick
import Quickshell
import qs

// A lightweight popup tooltip anchored to an item.
//
// Usage:
//   HoverHandler {
//       id: hover
//   }
//   Tooltip {
//       target: someItem
//       text: "Hello"
//       visible: hover.hovered
//   }
PopupWindow {
    id: root

    // The item the tooltip is positioned against.
    property Item target
    property string text: ""

    anchor {
        item: root.target
        edges: Edges.Bottom
        gravity: Edges.Bottom
        adjustment: PopupAdjustment.SlideX
        margins.bottom: -Globals.tooltip.gap
    }

    color: "transparent"
    implicitWidth: label.implicitWidth + 2 * Globals.tooltip.padding
    implicitHeight: label.implicitHeight + 2 * Globals.tooltip.padding

    Rectangle {
        anchors.fill: parent
        radius: Globals.tooltip.radius
        color: Globals.palette.surface

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            font: Globals.fonts.regular
            color: Globals.palette.text
        }
    }
}
