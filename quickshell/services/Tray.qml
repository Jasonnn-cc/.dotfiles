pragma Singleton

import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

Singleton {
    id: root
    property var items: SystemTray.items
}
