pragma Singleton

import Quickshell
import Quickshell.Wayland
import QtQuick

Singleton {
    id: root
    property var activeWindow: ToplevelManager.activeToplevel
    property string activeTitle: activeWindow?.title ?? ""
}
