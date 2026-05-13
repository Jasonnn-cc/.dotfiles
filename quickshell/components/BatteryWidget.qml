import QtQuick
import qs
import qs.services

Text {
    text: `${parseInt(Battery.percentage * 100)}% ${Battery.isCharging ? "󰂄" : ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹", "󰁹"][parseInt(Battery.percentage * 10)]}`
    font: Globals.fonts.regular
    color: Globals.palette.text
}
