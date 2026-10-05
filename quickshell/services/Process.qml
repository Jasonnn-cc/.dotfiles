pragma Singleton

import Quickshell
import Quickshell.Wayland
import QtQuick

Singleton {
    id: root

    readonly property var waylandWindow: ToplevelManager.activeToplevel

    readonly property string activeTitle: waylandWindow?.title ?? ""
    readonly property string activeClass: waylandWindow?.appId ?? ""
}
