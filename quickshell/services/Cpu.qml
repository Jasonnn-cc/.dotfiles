pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property int pollInterval: 1000

    // Total CPU load as a fraction (0..1), derived from the delta between polls.
    property real usage: 0
    readonly property int usagePercent: Math.round(usage * 100)

    property real _prevTotal: 0
    property real _prevIdle: 0
    property bool _hasPrev: false

    function parse(contents) {
        const parts = contents.split("\n")[0].trim().split(/\s+/);

        let total = 0;
        let idle = 0;
        for (let i = 1; i < parts.length; i++) {
            const value = parseInt(parts[i]) || 0;
            total += value;
            // Fields 4 and 5 are idle and iowait.
            if (i === 4 || i === 5)
                idle += value;
        }

        const totalDelta = total - root._prevTotal;
        const idleDelta = idle - root._prevIdle;
        if (root._hasPrev && totalDelta > 0)
            root.usage = Math.max(0, Math.min(1, (totalDelta - idleDelta) / totalDelta));

        root._prevTotal = total;
        root._prevIdle = idle;
        root._hasPrev = true;
    }

    FileView {
        id: stat
        path: "/proc/stat"
        blockLoading: true
        onLoaded: root.parse(text())
        onTextChanged: root.parse(text())
    }

    Timer {
        interval: root.pollInterval
        running: true
        repeat: true
        onTriggered: stat.reload()
    }
}
