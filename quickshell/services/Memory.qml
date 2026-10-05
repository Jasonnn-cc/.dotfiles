pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property int pollInterval: 1000
    readonly property int kbPerGB: 1024 * 1024

    property real totalKB: 0
    property real availableKB: 0

    readonly property real totalGB: totalKB / kbPerGB
    readonly property real availableGB: availableKB / kbPerGB

    // Memory remaining, rounded to the nearest tenth of a GB.
    readonly property real remainingGB: Math.round(availableGB * 10) / 10
    readonly property string remainingText: remainingGB.toFixed(1)

    function parse(contents) {
        const total = contents.match(/^MemTotal:\s+(\d+)\s*kB/m);
        const available = contents.match(/^MemAvailable:\s+(\d+)\s*kB/m);
        const free = contents.match(/^MemFree:\s+(\d+)\s*kB/m);

        if (total)
            root.totalKB = parseInt(total[1]);
        if (available)
            root.availableKB = parseInt(available[1]);
        else if (free)
            root.availableKB = parseInt(free[1]);
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        blockLoading: true
        onLoaded: root.parse(text())
        onTextChanged: root.parse(text())
    }

    Timer {
        interval: root.pollInterval
        running: true
        repeat: true
        onTriggered: meminfo.reload()
    }
}
