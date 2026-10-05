import qs
import qs.services

InformationWidget {
    id: root

    readonly property bool danger: Battery.percentage <= Globals.battery.dangerThreshold
    readonly property bool warning: Battery.percentage <= Globals.battery.warningThreshold

    text: `${parseInt(Battery.percentage * 100)}%`
    icon: Battery.isCharging ? "\uDB80\uDC84" : ["\uDB80\uDC7A", "\uDB80\uDC7B", "\uDB80\uDC7C", "\uDB80\uDC7D", "\uDB80\uDC7E", "\uDB80\uDC7F", "\uDB80\uDC80", "\uDB80\uDC81", "\uDB80\uDC82", "\uDB80\uDC79", "\uDB80\uDC79"][parseInt(Battery.percentage * 10)]
    value: Battery.percentage
    color: danger ? Globals.palette.danger : warning ? Globals.palette.warning : Globals.palette.text
}
