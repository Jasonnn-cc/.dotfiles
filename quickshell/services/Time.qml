pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs

Singleton {
    id: root
    property string time

    Process {
        id: dateProc
        command: ["date", Globals.timeFormat]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
