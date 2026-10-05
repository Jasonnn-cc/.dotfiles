import qs
import qs.services

InformationWidget {
    id: root

    readonly property bool danger: Cpu.usage >= Globals.cpu.dangerThreshold
    readonly property bool warning: Cpu.usage >= Globals.cpu.warningThreshold

    text: `${Cpu.usagePercent}%`
    icon: Globals.cpu.icon
    value: Cpu.usage
    color: danger ? Globals.palette.danger : warning ? Globals.palette.warning : Globals.palette.text
}
