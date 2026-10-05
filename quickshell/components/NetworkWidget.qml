import qs
import qs.services

InformationWidget {
    id: root

    readonly property bool danger: Network.level === 0
    readonly property bool warning: Network.level === 1

    widgetWidth: Globals.informationWidget.width * 2
    text: Network.name
    icon: Globals.network.icons[Network.level]
    value: Network.strength
    color: danger ? Globals.palette.danger : warning ? Globals.palette.warning : Globals.palette.text
}
