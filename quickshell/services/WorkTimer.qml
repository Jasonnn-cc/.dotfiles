pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs

Singleton {
    id: root

    // Seconds since boot, sampled from /proc/uptime.
    property real uptime: 0
    // Whether this boot session landed on a weekday morning.
    property bool eligible: false

    readonly property bool active: eligible && uptime < Globals.workTimer.durationSeconds
    readonly property real progress: Math.max(0, Math.min(1, uptime / Globals.workTimer.durationSeconds))

    readonly property int remainingSeconds: Math.max(0, Globals.workTimer.durationSeconds - Math.floor(uptime))

    // Remaining time as HH:MM:SS.
    readonly property string remaining: {
        const total = remainingSeconds;
        return pad(Math.floor(total / 3600)) + ":" + pad(Math.floor((total % 3600) / 60)) + ":" + pad(total % 60);
    }

    function pad(value) {
        return value < 10 ? "0" + value : "" + value;
    }

    function parseUptime(contents) {
        root.uptime = parseFloat(contents.trim().split(/\s+/)[0]) || 0;
    }

    FileView {
        id: uptimeFile
        path: "/proc/uptime"
        blockLoading: true
        onLoaded: root.parseUptime(text())
        onTextChanged: root.parseUptime(text())
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: uptimeFile.reload()
    }

    // Resolve the weekday and hour of the boot time once per session.
    Process {
        id: bootProc
        running: true
        command: ["sh", "-c", "u=$(cut -d. -f1 /proc/uptime); date -d \"-$u seconds\" +\"%u %H\""]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(/\s+/);
                const weekday = parseInt(parts[0]);
                const hour = parseInt(parts[1]);
                root.eligible = weekday >= 1 && weekday <= 5 &&
                    hour >= Globals.workTimer.firstBootHour && hour < Globals.workTimer.lastBootHour;
            }
        }
    }
}
