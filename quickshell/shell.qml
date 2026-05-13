import Quickshell
import QtQuick

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
                    width: 20
                },
                TopBarSeparator {},
                ProcessWidget {
                    width: 628
                },
                TopBarSeparator {}
            ]
            center: [
                TopBarSeparator {},
                ClockWidget {
                    width: 56
                },
                TopBarSeparator {},
                DateWidget {},
                TopBarSeparator {}
            ]
            right: [
                TopBarSeparator {},
                TrayWidget {},
                TopBarSeparator {},
                BatteryWidget {}
            ]
            color: Globals.palette.base
        }
    }
}
