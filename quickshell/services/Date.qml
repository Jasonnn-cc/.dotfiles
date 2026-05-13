pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs

Singleton {
    id: root
    property string date

    Process {
        id: dateProc
        command: ["date", Globals.dateFormat]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.date = this.text
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
