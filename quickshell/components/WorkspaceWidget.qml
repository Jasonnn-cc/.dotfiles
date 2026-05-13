import QtQuick
import qs.services
import qs

Text {
    text: `[${parseInt(Hyprland.activeWorkspace?.name ?? '0') % 10}]`
    font: Globals.fonts.regular
    color: Globals.palette.text
}
