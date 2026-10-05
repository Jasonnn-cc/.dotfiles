import Quickshell
import QtQuick
import QtQuick.Layouts

import qs
import qs.layouts
import qs.components

Scope {
    Variants {
        model: Quickshell.screens

        TopBar {
            id: topBar
            left: [
                WorkspaceWidget {
                    Layout.preferredWidth: 20
                },
                TopBarSeparator {},
                ProcessWidget {}
            ]
            center: [
                TopBarSeparator {},
                ClockWidget {
                    Layout.preferredWidth: 56
                },
                TopBarSeparator {},
                DateWidget {},
                TopBarSeparator {}
            ]
            right: [
                TopBarSeparator {},
                CpuWidget {},
                TopBarSeparator {},
                MemoryWidget {},
                TopBarSeparator {},
                NetworkWidget {},
                TopBarSeparator {},
                BatteryWidget {}
            ]
            color: Globals.palette.base
        }
    }
}
