pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root
    property var activeWorkspace: Hyprland.focusedWorkspace
}
