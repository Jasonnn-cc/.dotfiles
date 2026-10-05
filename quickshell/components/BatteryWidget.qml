import QtQuick
import qs
import qs.services

Text {
    id: root

    readonly property bool danger: Battery.percentage <= Globals.battery.dangerThreshold
    readonly property bool warning: Battery.percentage <= Globals.battery.warningThreshold

    text: `${parseInt(Battery.percentage * 100)}% ${Battery.isCharging ? "󰂄" : ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹", "󰁹"][parseInt(Battery.percentage * 10)]}`
    font: Globals.fonts.regular
    color: danger ? Globals.palette.danger : warning ? Globals.palette.warning : Globals.palette.text
}
