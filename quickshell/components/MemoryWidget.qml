import qs
import qs.services

InformationWidget {
    id: root

    readonly property bool danger: Memory.remainingGB <= Globals.memory.dangerThreshold
    readonly property bool warning: Memory.remainingGB <= Globals.memory.warningThreshold

    text: `${Memory.remainingText}GB`
    icon: Globals.memory.icon
    value: Memory.totalGB > 0 ? Memory.availableGB / Memory.totalGB : 0
    color: danger ? Globals.palette.danger : warning ? Globals.palette.warning : Globals.palette.text
}
