pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property var battery: QtObject {
        readonly property double warningThreshold: 0.15
        readonly property double dangerThreshold: 0.05
    }

    readonly property var cpu: QtObject {
        // Thresholds are a fraction of total CPU load.
        readonly property double warningThreshold: 0.8
        readonly property double dangerThreshold: 0.9
        readonly property string icon: "\uF4BC"
    }

    readonly property var memory: QtObject {
        // Thresholds are in GB of memory remaining.
        readonly property double warningThreshold: 2
        readonly property double dangerThreshold: 1
        readonly property string icon: "\uEFC5"
    }

    readonly property var topBar: QtObject {
        readonly property double padding: 8
        readonly property double spacing: 4
        readonly property double height: 30
    }

    readonly property var informationWidget: QtObject {
        // Fixed width shared by all InformationWidgets so their bars line up.
        readonly property double width: 74
    }

    readonly property var fonts: QtObject {
        readonly property font regular: Qt.font({
            family: "Fira Sans",
            pointSize: 12
        })
        readonly property font monospace: Qt.font({
            family: "FiraCode Nerd Font",
            pointSize: 12
        })
    }

    readonly property var palette: QtObject {
        // Colors stolen from Catppuccin Latte
        // readonly property string base: "#eff1f5"
        // readonly property string surface: "#ccd0da"
        // readonly property string accent: "#f5a97f"
        // readonly property string text: "#4c4f69"

        // Colors stolen from Catppuccin Mocha
        readonly property string base: "#1e1e2e"
        readonly property string surface: "#313244"
        readonly property string accent: "#f5c2e7"
        readonly property string text: "#cdd6f4"

        readonly property string warning: "#f9e2af"
        readonly property string danger: "#f38ba8"
    }

    readonly property string timeFormat: "+%H:%M:%S"
    readonly property string dateFormat: "+%a, %d %b %Y"
}
